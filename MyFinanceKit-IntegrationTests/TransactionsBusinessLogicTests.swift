@testable import MyFinanceKit

class TransactionsBusinessLogicTests: XCTestCase {

    func testGetTransactions() {
        let newExpectation = expectation(description: "Transactions fetched")

        let transactionsBusinessLogic = TransactionsBusinessLogic()
        let fromTo = FromToParameters(from: Date().oneMonthAgo, to: Date())

        _ = transactionsBusinessLogic.getTransactions(fromTo: fromTo)
            .done { transactions in
                XCTAssert(transactions.isEmpty == false)
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
