@testable import MyFinanceKit

class TransactionsBusinessLogicTests: ServiceClientTestCase {
    func testGetTransactions() {
        let newExpectation = expectation(description: "Transactions fetched")

        let now = Date()
        let dayBefore = now.dayBefore

        let expectedFromTo = FromToParameters(from: dayBefore, to: now)

        let expectedTransactions = [Factory.makeTransaction()]

        let halResponse = HALResponse(embedded: TransactionList(transactions: expectedTransactions))

        mockAppState.mockNetworkService.returnJSONDecodableValues = [halResponse]

        let transactionsBusinessLogic = TransactionsBusinessLogic(serviceProvider: mockAppState)

        _ = transactionsBusinessLogic.getTransactions(fromTo: expectedFromTo).done { transactions in
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .starling(.transactions))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .get)
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.parameters as? FromToParameters,
                           expectedFromTo)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(transactions, expectedTransactions)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
