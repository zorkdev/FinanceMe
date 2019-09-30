import XCTest
@testable import FinanceMeKit

class SpendingBusinessLogicTests: XCTestCase {
    func testIcon() {
        let spendingBusinessLogic = SpendingBusinessLogic()

        XCTAssertEqual(spendingBusinessLogic.icon(for: -100), "😱")
        XCTAssertEqual(spendingBusinessLogic.icon(for: -50), "😨")
        XCTAssertEqual(spendingBusinessLogic.icon(for: -20), "😰")
        XCTAssertEqual(spendingBusinessLogic.icon(for: 0), "😓")
        XCTAssertEqual(spendingBusinessLogic.icon(for: 20), "😳")
        XCTAssertEqual(spendingBusinessLogic.icon(for: 50), "🤔")
        XCTAssertEqual(spendingBusinessLogic.icon(for: 100), "😏")
        XCTAssertEqual(spendingBusinessLogic.icon(for: 200), "😇")
        XCTAssertEqual(spendingBusinessLogic.icon(for: 201), "🤑")
        XCTAssertEqual(spendingBusinessLogic.icon(for: .nan), "")
    }
}
