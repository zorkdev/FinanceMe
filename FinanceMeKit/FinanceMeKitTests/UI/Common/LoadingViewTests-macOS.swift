import XCTest
@testable import FinanceMeKit

final class LoadingViewTests: XCTestCase {
    func testView() {
        let loadingState = LoadingState()
        assert(view: LoadingView(loadingState))
        loadingState.isLoading = true
        assert(view: LoadingView(loadingState))
    }
}
