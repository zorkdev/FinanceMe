import XCTest
@testable import FinanceMe

class ContentViewTests: XCTestCase {
    func testView() {
        _ = ContentView().body
        XCTAssertTrue(ContentViewPreviews.previews is ContentView)
    }
}
