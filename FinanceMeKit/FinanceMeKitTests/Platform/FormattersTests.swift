import XCTest
@testable import FinanceMeKit

class FormattersTests: XCTestCase {
    func testLocale() {
        XCTAssertEqual(Formatters.locale.identifier, "en_GB")
    }

    #if os(iOS) || os(macOS)
    func testCurrency() {
        XCTAssertEqual(Formatters.currency.string(from: Decimal(1000.10)), "£1,000.10")
        XCTAssertEqual(Formatters.currency.string(from: Decimal(-1000.10)), "-£1,000.10")
    }

    func testRelativeDateFormatter() {
        let today = Date()
        XCTAssertEqual(Formatters.relativeDateFormatter.string(from: today), "Today")

        let yesterday = Formatters.locale.calendar.date(byAdding: .day, value: -1, to: today)!
        XCTAssertEqual(Formatters.relativeDateFormatter.string(from: yesterday), "Yesterday")

        let date = ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!
        XCTAssertEqual(Formatters.relativeDateFormatter.string(from: date), "Tuesday, 1 January 2019")
    }

    func testYear() {
        let date = ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!
        XCTAssertEqual(Formatters.year.string(from: date), "2019")
    }

    func testMonth() {
        let date = ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!
        XCTAssertEqual(Formatters.month.string(from: date), "January")
    }
    #endif
}
