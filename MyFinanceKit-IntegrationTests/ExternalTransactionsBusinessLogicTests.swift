import PromiseKit
@testable import MyFinanceKit

class ExternalTransactionsBusinessLogicTests: XCTestCase {

    func testGetExternalTransactions() {
        let newExpectation = expectation(description: "External transactions fetched")

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()
        let fromTo = FromToParameters(from: Date().oneMonthAgo, to: Date())

        _ = externalTransactionsBusinessLogic.getExternalTransactions(fromTo: fromTo)
            .done { transactions in
                XCTAssert(transactions.isEmpty == false)
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreateDeleteExternalTransaction() {
        let createdExpectation = expectation(description: "External transaction created")
        let deletedExpectation = expectation(description: "External transaction deleted")

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()

        let transaction = Transaction(amount: -1,
                                      direction: .outbound,
                                      created: Date(),
                                      narrative: "Test",
                                      source: .externalOutbound)

        _ = externalTransactionsBusinessLogic.create(transaction: transaction)
            .then { transaction -> Promise<Void> in
                createdExpectation.fulfill()
                return externalTransactionsBusinessLogic.delete(transaction: transaction)
            }.done {
                deletedExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
