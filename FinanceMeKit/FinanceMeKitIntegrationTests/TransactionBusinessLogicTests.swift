import XCTest
@testable import FinanceMeKit

class TransactionBusinessLogicTests: IntegrationTestCase {
    func testGetTransactions() {
        appState.transactionBusinessLogic.getTransactions().assertSuccess(self, once: false) {}
        appState.transactionBusinessLogic.transactions.assertSuccess(self) { XCTAssertFalse($0.isEmpty) }
    }

    func testCreateUpdateDelete() {
        appState.transactionBusinessLogic.create(transaction: Transaction.stub).assertSuccess(self, once: false) {}
        var transactionExpectation: Transaction?
        appState.transactionBusinessLogic.transactions.assertSuccess(self) { transactionExpectation = $0.last }

        guard let transaction = transactionExpectation else {
            XCTFail("Missing user.")
            return
        }

        appState.transactionBusinessLogic.update(transaction: transaction).assertSuccess(self, once: false) {}
        appState.transactionBusinessLogic.delete(transaction: transaction).assertSuccess(self, once: false) {}
    }

    func testReconcile() {
        appState.transactionBusinessLogic.reconcile().assertSuccess(self, once: false) {}
        waitForEvent {}
    }
}
