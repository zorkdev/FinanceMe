import XCTest
@testable import FinanceMeKit

class FormattersTests: XCTestCase {
    func testLocale() {
        XCTAssertEqual(Formatters.locale.identifier, "en_GB")
    }

    func testCurrency() {
        XCTAssertEqual(Formatters.currency.string(from: Decimal(string: "1000.10")!), "£1,000.10")
        XCTAssertEqual(Formatters.currency.string(from: Decimal(string: "-1000.10")!), "-£1,000.10")
    }
}
