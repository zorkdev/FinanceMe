import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class TransactionDetailViewTests: XCTestCase {
    func testView() {
        assert(view: TransactionDetailView(transaction: Transaction.stub, appState: MockAppState()),
               previews: TransactionDetailViewPreviews.self)
    }
}
