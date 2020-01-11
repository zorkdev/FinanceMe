import XCTest
@testable import FinanceMeKit

final class NumberFormatterExtensionsTests: XCTestCase {
    func testStringFromDecimal() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let decimal = Decimal(10.1)
        XCTAssertEqual(formatter.string(from: decimal), "10.1")
    }

    func testDecimalFromString() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let expectedDecimal = Decimal(10.1)
        XCTAssertEqual(formatter.decimal(from: "10.1"), expectedDecimal)
    }
}
