import XCTest
@testable import FinanceMeKit

class DecimalExtensionsTests: XCTestCase {
    func testRounded() {
        XCTAssertEqual(Decimal(string: "1.1")?.rounded(scale: 0, mode: .down),
                       Decimal(string: "1"))

        XCTAssertEqual(Decimal(string: "1.1")?.rounded(scale: 0, mode: .up),
                       Decimal(string: "2"))
    }

    func testFloored() {
        XCTAssertEqual(Decimal(string: "1.1")?.floored,
                       Decimal(string: "1"))

        XCTAssertEqual(Decimal(string: "-1.1")?.floored,
                       Decimal(string: "-1"))
    }

    func testInteger() {
        XCTAssertEqual(Decimal(string: "12.34")?.integer,
                       Decimal(string: "12"))

        XCTAssertEqual(Decimal(string: "-12.34")?.integer,
                       Decimal(string: "12"))
    }

    func testFraction() {
        XCTAssertEqual(Decimal(string: "12.34")?.fraction,
                       Decimal(string: "34"))

        XCTAssertEqual(Decimal(string: "-12.34")?.fraction,
                       Decimal(string: "34"))
    }
}
