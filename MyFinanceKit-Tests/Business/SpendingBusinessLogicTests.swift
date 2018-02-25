@testable import MyFinanceKit

class SpendingBusinessLogicTests: XCTestCase {

    func testAllowanceIcon() {
        let spendingBusinessLogic = SpendingBusinessLogic()

        let user1 = Factory.makeUser(allowance: -100)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user1), "😱")

        let user2 = Factory.makeUser(allowance: -50)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user2), "😨")

        let user3 = Factory.makeUser(allowance: -20)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user3), "😰")

        let user4 = Factory.makeUser(allowance: 0)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user4), "😓")

        let user5 = Factory.makeUser(allowance: 20)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user5), "😳")

        let user6 = Factory.makeUser(allowance: 50)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user6), "🤔")

        let user7 = Factory.makeUser(allowance: 100)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user7), "😏")

        let user8 = Factory.makeUser(allowance: 200)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user8), "😇")

        let user9 = Factory.makeUser(allowance: 201)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user9), "🤑")

        let user10 = Factory.makeUser(allowance: Double.nan)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user10), "")
    }

}
