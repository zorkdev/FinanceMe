import XCTest
@testable import FinanceMeKit

final class NumberFormatterExtensionsTests: XCTestCase {
    func testStringFromDecimal() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        XCTAssertEqual(formatter.string(from: 10.1), "10.1")
    }

    func testDecimalFromString() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        XCTAssertEqual(formatter.double(from: "10.1"), 10.1)
    }
}
