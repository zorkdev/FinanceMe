@testable import MyFinanceKit

class TransactionsBusinessLogicTests: IntegrationTestCase {

    func testGetTransactions() {
        let newExpectation = expectation(description: "Transactions fetched")

        let transactionsBusinessLogic = TransactionsBusinessLogic(serviceProvider: config.appState)
        let fromTo = FromToParameters(from: Date().oneMonthAgo, to: Date())

        _ = transactionsBusinessLogic.getTransactions(fromTo: fromTo)
            .done { transactions in
                XCTAssertFalse(transactions.isEmpty)
                newExpectation.fulfill()
            }.catch { error in
                XCTFail(error.localizedDescription)
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
