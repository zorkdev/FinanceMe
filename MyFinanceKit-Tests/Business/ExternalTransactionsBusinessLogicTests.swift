@testable import MyFinanceKit

class ExternalTransactionsBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
    }

    func testGetExternalTransactions() {
        let newExpectation = expectation(description: "External Transactions fetched")

        let now = Date()
        let dayBefore = now.dayBefore

        let expectedFromTo = FromToParameters(from: dayBefore, to: now)

        let expectedTransactions = [Transaction(id: "id",
                                                currency: "GBP",
                                                amount: 10.30,
                                                direction: .inbound,
                                                created: Date(),
                                                narrative: "Test",
                                                source: .fasterPaymentsIn,
                                                balance: 100)]

        mockNetworkService.returnJSONDecodableValues = [expectedTransactions]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(networkService: mockNetworkService)

        _ = externalTransactionsBusinessLogic.getExternalTransactions(fromTo: expectedFromTo).done { transactions in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.transactions))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.parameters as? FromToParameters, expectedFromTo)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(transactions, expectedTransactions)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreateTransaction() {
        let newExpectation = expectation(description: "Transaction created")

        let expectedTransaction = Transaction(id: "id",
                                              currency: "GBP",
                                              amount: 10.30,
                                              direction: .inbound,
                                              created: Date(),
                                              narrative: "Test",
                                              source: .fasterPaymentsIn,
                                              balance: 100)

        mockNetworkService.returnJSONDecodableValues = [expectedTransaction]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(networkService: mockNetworkService)

        _ = externalTransactionsBusinessLogic.create(transaction: expectedTransaction).done { transaction in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.transactions))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .post)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.body as? Transaction, expectedTransaction)
            XCTAssertEqual(transaction, expectedTransaction)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testDeleteTransaction_Success() {
        let newExpectation = expectation(description: "Transaction deleted")

        let expectedTransaction = Transaction(id: "id",
                                              currency: "GBP",
                                              amount: 10.30,
                                              direction: .inbound,
                                              created: Date(),
                                              narrative: "Test",
                                              source: .fasterPaymentsIn,
                                              balance: 100)

        mockNetworkService.returnJSONDecodableValues = [expectedTransaction]

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(networkService: mockNetworkService)

        _ = externalTransactionsBusinessLogic.delete(transaction: expectedTransaction).done {

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API,
                           .zorkdev(.transaction(expectedTransaction.id!)))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .delete)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testDeleteTransaction_Failure() {
        let newExpectation = expectation(description: "Transaction delete failed")

        let expectedTransaction = Transaction(currency: "GBP",
                                              amount: 10.30,
                                              direction: .inbound,
                                              created: Date(),
                                              narrative: "Test",
                                              source: .fasterPaymentsIn,
                                              balance: 100)

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(networkService: mockNetworkService)

        _ = externalTransactionsBusinessLogic.delete(transaction: expectedTransaction).catch { error in

            XCTAssertEqual(error as? AppError, .apiPathInvalid)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
