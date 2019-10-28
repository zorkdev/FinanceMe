import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class HomeNavigationBarViewTests: XCTestCase {
    func testView() {
        assert(view: HomeNavigationBarView(appState: MockAppState()), previews: HomeNavigationBarViewPreviews.self)
    }
}
