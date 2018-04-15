@testable import MyFinanceKit

class FormattersTests: XCTestCase {

    let date: Date = {
        var components = DateComponents()
        components.year = 2018
        components.month = 1
        components.day = 7
        components.hour = 15
        components.minute = 30
        components.second = 10

        return Calendar.current.date(from: components)!
    }()

    let positiveAmount = NSNumber(value: 100.0)
    let negativeAmount = NSNumber(value: -100.0)

    func testCurrencySymbol() {
        XCTAssertEqual(Formatters.currencySymbol, "£")
    }

    func testDecimalSeparator() {
        XCTAssertEqual(Formatters.decimalSeparator, ".")
    }

    func testAPIDateFormatter() {
        XCTAssertEqual(Formatters.apiDate.string(from: date), "2018-01-07")
    }

    func testAPIDateTimeFormatter() {
        XCTAssertEqual(Formatters.apiDateTime.string(from: date), "2018-01-07T15:30:10.000Z")
    }

    func testDateFormatter() {
        XCTAssertEqual(Formatters.date.string(from: date), "7 Jan 2018")
    }

    func testDateTimeFormatter() {
        XCTAssertEqual(Formatters.dateTime.string(from: date), "7 Jan 2018 at 15:30")
    }

    func testDateWithoutYearFormatter() {
        XCTAssertEqual(Formatters.dateWithoutYear.string(from: date), "Sunday, 7 January")
    }

    func testDateWithYearFormatter() {
        XCTAssertEqual(Formatters.dateWithYear.string(from: date), "Sunday, 7 January 2018")
    }

    func testMonthFormatter() {
        XCTAssertEqual(Formatters.month.string(from: date), "January")
    }

    func testMonthShortFormatter() {
        XCTAssertEqual(Formatters.monthShort.string(from: date), "Jan")
    }

    func testYearFormatter() {
        XCTAssertEqual(Formatters.year.string(from: date), "2018")
    }

    func testCurrencyFormatter() {
        XCTAssertEqual(Formatters.currency.string(from: positiveAmount), "£100.00")
        XCTAssertEqual(Formatters.currency.string(from: negativeAmount), "-£100.00")
    }

    func testCurrencyNoSignFormatter() {
        XCTAssertEqual(Formatters.currencyNoSign.string(from: positiveAmount), "£100.00")
        XCTAssertEqual(Formatters.currencyNoSign.string(from: negativeAmount), "£100.00")
    }

    func testCurrencyPlusSignFormatter() {
        XCTAssertEqual(Formatters.currencyPlusSign.string(from: positiveAmount), "+£100.00")
        XCTAssertEqual(Formatters.currencyPlusSign.string(from: negativeAmount), "£100.00")
    }

    func testCurrencyPlusMinusSignFormatter() {
        XCTAssertEqual(Formatters.currencyPlusMinusSign.string(from: positiveAmount), "+£100.00")
        XCTAssertEqual(Formatters.currencyPlusMinusSign.string(from: negativeAmount), "-£100.00")
    }

    func testCurrencyNoFractionsFormatter() {
        XCTAssertEqual(Formatters.currencyNoFractions.string(from: positiveAmount), "£100")
        XCTAssertEqual(Formatters.currencyNoFractions.string(from: negativeAmount), "-£100")
    }

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

    func testCreateAmount() {
        let amountString = "£12.21"

        XCTAssertEqual(Formatters.createAmount(from: amountString), 12.21)
    }

    func testSanitiseAmount() {
        var amountString = "12,21"

        XCTAssertEqual(Formatters.sanitise(amount: amountString), "£12.21")

        amountString = "£"

        XCTAssertEqual(Formatters.sanitise(amount: amountString), "")
    }

    func testFormatRelativeDefault() {
        let expectedString = "Monday, 4 December 2017"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        let date = dateFormatter.date(from: expectedString)!

        XCTAssertEqual(Formatters.formatRelative(date: date), expectedString)
    }

}
