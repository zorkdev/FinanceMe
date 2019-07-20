import PromiseKit
@testable import MyFinanceKit

class ExternalTransactionsBusinessLogicTests: IntegrationTestCase {
    func testGetExternalTransactions() {
        let newExpectation = expectation(description: "External transactions fetched")

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: config.appState)
        let fromTo = FromToParameters(from: Date().oneMonthAgo, to: Date())

        _ = externalTransactionsBusinessLogic.getExternalTransactions(fromTo: fromTo)
            .done { transactions in
                XCTAssert(transactions.isEmpty == false)
                newExpectation.fulfill()
            }.catch { error in
                XCTFail(error.localizedDescription)
            }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreateUpdateDeleteExternalTransaction() {
        let createdExpectation = expectation(description: "External transaction created")
        let deletedExpectation = expectation(description: "External transaction deleted")

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: config.appState)

        let transaction = Transaction(amount: -1,
                                      direction: .outbound,
                                      created: Date(),
                                      narrative: "Test",
                                      source: .externalOutbound)

        _ = externalTransactionsBusinessLogic.create(transaction: transaction)
            .then { transaction -> Promise<Transaction> in
                createdExpectation.fulfill()
                return externalTransactionsBusinessLogic.update(transaction: transaction)
            }.then { transaction -> Promise<Void> in
                externalTransactionsBusinessLogic.delete(transaction: transaction)
            }.done {
                deletedExpectation.fulfill()
            }.catch { error in
                XCTFail(error.localizedDescription)
            }

        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
