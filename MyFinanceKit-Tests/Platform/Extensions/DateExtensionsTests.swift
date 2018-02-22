@testable import MyFinanceKit

class DateExtensionsTests: XCTestCase {

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

        let yesterday = Calendar.current.date(byAdding: components, to: Date())!

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

        let components = Calendar.current.dateComponents([.year, .month, .day],
                                                         from: now)

        let startOfDay = Calendar.current.date(from: components)

        XCTAssertEqual(now.startOfDay, startOfDay)
    }

    func testStartOfWeek() {
        let now = Date()

        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                         from: now)

        let startOfWeek = Calendar.current.date(from: components)

        XCTAssertEqual(now.startOfWeek, startOfWeek)
    }

    func testStartOfYear() {
        let now = Date()

        let components = Calendar.current.dateComponents([.year],
                                                         from: now)

        let startOfYear = Calendar.current.date(from: components)

        XCTAssertEqual(now.startOfYear, startOfYear)
    }

    func testEndOfWeek() {
        let now = Date()

        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                         from: now)
        let startOfWeek = Calendar.current.date(from: components)!

        var newComponents = DateComponents()
        newComponents.weekOfYear = 1

        let endOfWeek = Calendar.current.date(byAdding: newComponents, to: startOfWeek)

        XCTAssertEqual(now.endOfWeek, endOfWeek)
    }

    func testOneMonthAgo() {
        let now = Date()

        var components = DateComponents()
        components.month = -1

        let oneMonthAgo = Calendar.current.date(byAdding: components, to: now)

        XCTAssertEqual(now.oneMonthAgo, oneMonthAgo)
    }

    func testDaysInMonth() {
        var components = DateComponents()
        components.year = 2018
        components.month = 1

        let january = Calendar.current.date(from: components)!

        XCTAssertEqual(january.daysInMonth, 31)
    }

    func testWeeksInMonth() {
        var components = DateComponents()
        components.year = 2018
        components.month = 1

        let january = Calendar.current.date(from: components)!

        XCTAssertEqual(january.weeksInMonth, 31 / 7)
    }

    func testDayBefore() {
        let now = Date()

        var components = DateComponents()
        components.day = -1

        let dayBefore = Calendar.current.date(byAdding: components, to: now)

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
        let january1 = Calendar.current.date(from: components)!

        components.day = 10
        let january10 = Calendar.current.date(from: components)!

        XCTAssertEqual(january10.numberOfDays(from: january1), 9)
    }

    func testNext() {
        let day = 5

        var components = DateComponents()
        components.year = 2018
        components.month = 1
        components.day = 10
        let january10 = Calendar.current.date(from: components)!

        components.month = 2
        components.day = day
        let february5 = Calendar.current.date(from: components)!

        XCTAssertEqual(january10.next(day: day, direction: .forward), february5)
    }

}
