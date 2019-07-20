@testable import MyFinanceKit

class PaydayTests: XCTestCase {
    func testPayday() {
        let payday = Payday(intValue: 1)

        XCTAssertEqual(payday.intValue, 1)
        XCTAssertEqual(payday.stringValue, "1")
        XCTAssertEqual(payday.description, "1")
    }

    func testPaydays() {
        for index in 1...28 {
            XCTAssertTrue(Paydays.values.map { $0.intValue }.contains(index))
        }
    }
}
