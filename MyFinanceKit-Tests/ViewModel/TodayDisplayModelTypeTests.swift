@testable import MyFinanceKit

class TodayDisplayModelTypeTests: XCTestCase {

    let displayModel = MockTodayDisplayModel()

    func testDefaultAmount() {
        XCTAssertEqual(MockTodayDisplayModel.defaultAmount, "£0.00")
    }

    func testAmountAttributedString() {
        let positiveAmount = MockTodayDisplayModel.amountAttributedString(from: "£10.00")
        let negativeAmount = MockTodayDisplayModel.amountAttributedString(from: "-£10.00")

        XCTAssertEqual(positiveAmount.string, "£10.00")
        XCTAssertEqual(negativeAmount.string, "-£10.00")
    }

}
