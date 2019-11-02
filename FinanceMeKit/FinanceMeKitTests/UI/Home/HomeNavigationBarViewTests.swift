import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class HomeNavigationBarViewTests: XCTestCase {
    func testView() {
        let loadingState = LoadingState()
        assert(view: HomeNavigationBarView(appState: MockAppState(), loadingState: loadingState),
               previews: HomeNavigationBarViewPreviews.self)
        loadingState.isLoading = true
        assert(view: HomeNavigationBarView(appState: MockAppState(), loadingState: loadingState))
    }
}
