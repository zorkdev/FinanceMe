import XCTest
@testable import FinanceMe

class ContentViewTests: XCTestCase {
    func testView() {
        assert(view: ContentView(), previews: ContentViewPreviews.self)
    }
}
