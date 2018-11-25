@testable import MyFinanceKit

class ExternalTransactionsBusinessLogicTests: ServiceClientTestCase {

    func testGetExternalTransactions() {
        let newExpectation = expectation(description: "External Transactions fetched")

        let now = Date()
        let dayBefore = now.dayBefore

        let expectedFromTo = FromToParameters(from: dayBefore, to: now)

        let expectedTransactions = [Factory.makeTransaction()]

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedTransactions]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.getExternalTransactions(fromTo: expectedFromTo).done { transactions in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .zorkdev(.transactions))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .get)
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.parameters as? FromToParameters,
                           expectedFromTo)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(transactions, expectedTransactions)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreateTransaction() {
        let newExpectation = expectation(description: "Transaction created")

        let expectedTransaction = Factory.makeTransaction()

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedTransaction]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.create(transaction: expectedTransaction).done { transaction in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .zorkdev(.transactions))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .post)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.body as? Transaction, expectedTransaction)
            XCTAssertEqual(transaction, expectedTransaction)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateTransaction_Success() {
        let newExpectation = expectation(description: "Transaction updated")

        let expectedTransaction = Factory.makeTransaction()

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedTransaction]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.update(transaction: expectedTransaction).done { transaction in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API,
                           .zorkdev(.transaction(expectedTransaction.id!)))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .put)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.body as? Transaction, expectedTransaction)
            XCTAssertEqual(transaction, expectedTransaction)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateTransaction_Failure() {
        let newExpectation = expectation(description: "Transaction update failed")

        let expectedTransaction = Transaction(amount: 10.30,
                                              direction: .inbound,
                                              created: Date(),
                                              narrative: "Test",
                                              source: .fasterPaymentsIn)

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.update(transaction: expectedTransaction).catch { error in

            XCTAssertEqual(error as? AppError, .apiPathInvalid)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testDeleteTransaction_Success() {
        let newExpectation = expectation(description: "Transaction deleted")

        let expectedTransaction = Factory.makeTransaction()

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedTransaction]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.delete(transaction: expectedTransaction).done {

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API,
                           .zorkdev(.transaction(expectedTransaction.id!)))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .delete)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testDeleteTransaction_Failure() {
        let newExpectation = expectation(description: "Transaction delete failed")

        let expectedTransaction = Transaction(amount: 10.30,
                                              direction: .inbound,
                                              created: Date(),
                                              narrative: "Test",
                                              source: .fasterPaymentsIn)

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.delete(transaction: expectedTransaction).catch { error in

            XCTAssertEqual(error as? AppError, .apiPathInvalid)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testReconcile_Success() {
        let newExpectation = expectation(description: "Transactions reconciled")

        mockAppState.mockNetworkService.returnDataValue = Data()

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.reconcile().done {

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API,
                           .zorkdev(.reconcile))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .post)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testReconcile_Failure() {
        let newExpectation = expectation(description: "Reconciliation failed")

        mockAppState.mockNetworkService.returnErrorValue = APIError.badRequest

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = externalTransactionsBusinessLogic.reconcile().catch { error in

            XCTAssertEqual(error as? APIError, .badRequest)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
