import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class HomeViewTests: XCTestCase {
    func testView() {
        assert(view: HomeView(appState: MockAppState()), previews: HomeViewPreviews.self)
    }
}
