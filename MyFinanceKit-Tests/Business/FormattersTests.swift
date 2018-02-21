@testable import MyFinanceKit

class FormattersTests: XCTestCase {

    func testFormatRelativeToday() {
        let date = Date()
        XCTAssertEqual(Formatters.formatRelative(date: date), "Today")
    }

    func testFormatRelativeYesterday() {
        let date = Date().dayBefore
        XCTAssertEqual(Formatters.formatRelative(date: date), "Yesterday")
    }

    func testFormatRelativeThisYear() {
        let date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!

        guard date.isToday == false, date.isYesterday == false, date.isThisYear == true else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        let expectedString = dateFormatter.string(from: date)

        XCTAssertEqual(Formatters.formatRelative(date: date), expectedString)
    }

    func testFormatRelativeDefault() {
        let expectedString = "Monday, 4 December 2017"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        let date = dateFormatter.date(from: expectedString)!

        XCTAssertEqual(Formatters.formatRelative(date: date), expectedString)
    }

}
