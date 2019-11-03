import XCTest
import SwiftUI
@testable import FinanceMeKit

class LoadingViewTests: XCTestCase {
    struct TestView: View {
        let loadingState: LoadingState

        var body: some View {
            Spacer().loading(loadingState)
        }
    }

    func testView() {
        let loadingState = LoadingState()
        assert(view: TestView(loadingState: loadingState))
        loadingState.isLoading = true
        assert(view: TestView(loadingState: loadingState))
    }
}
