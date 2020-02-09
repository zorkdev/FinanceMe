import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class RootViewTests: XCTestCase {
    func testView() {
        let appState = MockAppState()
        assert(view: RootView(appState: appState), previews: RootViewPreviews.self)
        appState.mockSessionService.hasSession = true
        assert(view: RootView(appState: appState), previews: RootViewPreviews.self)
    }
}
