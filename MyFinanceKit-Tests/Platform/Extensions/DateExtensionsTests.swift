@testable import MyFinanceKit

class DateExtensionsTests: XCTestCase {

    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_GB")
        calendar.timeZone = TimeZone(identifier: "Europe/London")!
        return calendar
    }()

    override func tearDown() {
        super.tearDown()

        NSTimeZone.resetSystemTimeZone()
    }

    func testIsToday() {
        XCTAssertTrue(Date().isToday)
    }

    func testIsYesterday() {
        var components = DateComponents()
        components.day = -1

        let yesterday = calendar.date(byAdding: components, to: Date())!

        XCTAssertTrue(yesterday.isYesterday)
    }

    func testIsThisWeek() {
        XCTAssertTrue(Date().isThisWeek)
    }

    func testIsThisYear() {
        XCTAssertTrue(Date().isThisYear)
    }

    func testStartOfDay() {
        let now = Date()

        let components = calendar.dateComponents([.year, .month, .day],
                                                         from: now)

        let startOfDay = calendar.date(from: components)

        XCTAssertEqual(now.startOfDay, startOfDay)
    }

    func testStartOfWeek() {
        let now = Date()

        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                         from: now)

        let startOfWeek = calendar.date(from: components)

        XCTAssertEqual(now.startOfWeek, startOfWeek)
    }

    func testStartOfYear() {
        let now = Date()

        let components = calendar.dateComponents([.year],
                                                         from: now)

        let startOfYear = calendar.date(from: components)

        XCTAssertEqual(now.startOfYear, startOfYear)
    }

    func testEndOfWeek() {
        let now = Date()

        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                         from: now)
        let startOfWeek = calendar.date(from: components)!

        var newComponents = DateComponents()
        newComponents.weekOfYear = 1

        let endOfWeek = calendar.date(byAdding: newComponents, to: startOfWeek)

        XCTAssertEqual(now.endOfWeek, endOfWeek)
    }

    func testOneMonthAgo() {
        let now = Date()

        var components = DateComponents()
        components.month = -1

        let oneMonthAgo = calendar.date(byAdding: components, to: now)

        XCTAssertEqual(now.oneMonthAgo, oneMonthAgo)
    }

    func testDaysInMonth() {
        var components = DateComponents()
        components.year = 2018
        components.month = 1

        let january = calendar.date(from: components)!

        XCTAssertEqual(january.daysInMonth, 31)
    }

    func testWeeksInMonth() {
        var components = DateComponents()
        components.year = 2018
        components.month = 1

        let january = calendar.date(from: components)!

        XCTAssertEqual(january.weeksInMonth, 31 / 7)
    }

    func testDayBefore() {
        let now = Date()

        var components = DateComponents()
        components.day = -1

        let dayBefore = calendar.date(byAdding: components, to: now)

        XCTAssertEqual(now.dayBefore, dayBefore)
    }

    func testIsInSameDay() {
        let now = Date()

        XCTAssertTrue(now.isInSameDay(as: now))
    }

    func testNumberOfDays() {
        var components = DateComponents()
        components.year = 2018
        components.month = 1
        components.day = 1
        let january1 = calendar.date(from: components)!

        components.day = 10
        let january10 = calendar.date(from: components)!

        XCTAssertEqual(january10.numberOfDays(from: january1), 9)
    }

    func testNext() {
        let day = 5

        var components = DateComponents()
        components.year = 2018
        components.month = 1
        components.day = 10
        let january10 = calendar.date(from: components)!

        components.month = 2
        components.day = day
        let february5 = calendar.date(from: components)!

        XCTAssertEqual(january10.next(day: day, direction: .forward), february5)
    }

}
