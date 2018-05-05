@testable import MyFinanceKit

class TodayDisplayModelTypeTests: XCTestCase {

    let displayModel = MockTodayDisplayModel()

    func testDefaultAmount() {
        XCTAssertEqual(MockTodayDisplayModel.defaultAmount, "£0.00")
    }

    func testAmountAttributedString() {
        let positiveAmount = MockTodayDisplayModel.attributedString(from: 10)
        let negativeAmount = MockTodayDisplayModel.attributedString(from: -10)

        XCTAssertEqual(positiveAmount.string, "£10.00")
        XCTAssertEqual(negativeAmount.string, "-£10.00")
    }

}
