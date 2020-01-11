import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class TransactionNavigationViewTests: XCTestCase {
    func testView() {
        assert(view: TransactionNavigationView(transaction: Transaction.stub, appState: MockAppState()),
               previews: TransactionNavigationViewPreviews.self)
    }
}
