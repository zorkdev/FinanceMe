import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class FeedViewTests: XCTestCase {
    func testView() {
        assert(view: FeedView(appState: MockAppState(), loadingState: LoadingState()), previews: FeedViewPreviews.self)
    }
}
