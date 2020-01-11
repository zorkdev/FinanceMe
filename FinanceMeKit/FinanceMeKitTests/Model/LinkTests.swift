import XCTest
@testable import FinanceMeKit

final class LinkTests: XCTestCase {
    func testLinks() {
        XCTAssertEqual(Link.urlScheme.absoluteString, "financeme://")
    }
}
