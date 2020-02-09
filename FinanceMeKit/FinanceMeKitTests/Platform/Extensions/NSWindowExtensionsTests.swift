import XCTest
@testable import FinanceMeKit

final class NSWindowExtensionsTests: XCTestCase {
    func testWindow() {
        let window = NSWindow(width: 100, height: 200, title: "Title")

        XCTAssertEqual(window.title, "Title")
        XCTAssertFalse(window.isReleasedWhenClosed)
        XCTAssertEqual(window.tabbingMode, .disallowed)
    }
}
