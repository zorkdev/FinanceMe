@testable import MyFinanceKit

class TransactionsBusinessLogicTests: IntegrationTestCase {

    func testGetTransactions() {
        let newExpectation = expectation(description: "Transactions fetched")

        let transactionsBusinessLogic = TransactionsBusinessLogic(networkService: config.appState.networkService)
        let fromTo = FromToParameters(from: Date().oneMonthAgo, to: Date())

        _ = transactionsBusinessLogic.getTransactions(fromTo: fromTo)
            .done { transactions in
                XCTAssertFalse(transactions.isEmpty)
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
