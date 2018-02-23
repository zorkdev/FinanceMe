@testable import MyFinanceKit

class TodayDisplayModelTypeTests: XCTestCase {

    let displayModel = MockTodayDisplayModel()

    func testDefaultAmount() {
        XCTAssertEqual(displayModel.defaultAmount, "£0.00")
    }

    func testAmountAttributedString() {
        let positiveAmount = displayModel.amountAttributedString(from: "£10.00")
        let negativeAmount = displayModel.amountAttributedString(from: "-£10.00")

        XCTAssertEqual(positiveAmount.string, "£10.00")
        XCTAssertEqual(negativeAmount.string, "-£10.00")
    }

}
