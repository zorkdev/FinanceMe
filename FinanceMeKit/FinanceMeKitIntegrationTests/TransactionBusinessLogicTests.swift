import XCTest
@testable import FinanceMeKit

class TransactionBusinessLogicTests: IntegrationTestCase {
    func testGetTransactions() {
        appState.transactionBusinessLogic.getTransactions().assertSuccess(self) {}
        appState.transactionBusinessLogic.transactions.assertSuccess(self) { XCTAssertFalse($0.isEmpty) }
    }

    func testCreateUpdateDelete() {
        var transaction: Transaction?
        appState.transactionBusinessLogic.create(transaction: Transaction.stub).assertSuccess(self) {}
        appState.transactionBusinessLogic.transactions.assertSuccess(self) { transaction = $0.last }
        appState.transactionBusinessLogic.update(transaction: transaction!).assertSuccess(self) {}
        appState.transactionBusinessLogic.delete(transaction: transaction!).assertSuccess(self) {}
    }
}
