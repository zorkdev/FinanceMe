import XCTest
@testable import FinanceMeKit

class TransactionBusinessLogicTests: IntegrationTestCase {
    func testGetTransactions() {
        appState.transactionBusinessLogic.getTransactions().assertSuccess(self) {}
        appState.transactionBusinessLogic.transactions.assertSuccess(self) { XCTAssertFalse($0.isEmpty) }
    }
}
