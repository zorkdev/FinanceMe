import XCTest
@testable import FinanceMeKit

class LinkTests: XCTestCase {
    func testLinks() {
        XCTAssertEqual(Link.urlScheme.absoluteString, "financeme://")
    }
}
