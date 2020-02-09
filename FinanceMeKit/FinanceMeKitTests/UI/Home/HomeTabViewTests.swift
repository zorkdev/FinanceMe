import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class HomeTabViewTests: XCTestCase {
    func testView() {
        let selectionState = SelectionState()

        let view = HomeTabView(appState: MockAppState(),
                               loadingState: LoadingState(),
                               errorViewModel: ErrorViewModel(),
                               selectionState: selectionState)

        assert(view: view)
        selectionState.selectedSegment = 1
        waitForEvent {}
        selectionState.selectedSegment = 2
        waitForEvent {}
    }
}
