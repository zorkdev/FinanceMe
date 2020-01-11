import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class BalancesViewTests: XCTestCase {
    func testView() {
        let appState = MockAppState()
        appState.mockSummaryBusinessLogic.summaryReturnValue = Summary.stub

        assert(view: BalancesView(appState: appState), previews: BalancesViewPreviews.self)
    }
}
