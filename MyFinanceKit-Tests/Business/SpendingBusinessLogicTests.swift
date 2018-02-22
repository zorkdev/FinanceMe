@testable import MyFinanceKit

class SpendingBusinessLogicTests: XCTestCase {

    //swiftlint:disable:next function_body_length
    func testAllowanceIcon() {
        let spendingBusinessLogic = SpendingBusinessLogic()

        let user1 = User(name: "User Name",
                        payday: 10,
                        startDate: Date(),
                        largeTransaction: 10,
                        allowance: -100)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user1), "😱")

        let user2 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: -50)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user2), "😨")

        let user3 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: -20)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user3), "😰")

        let user4 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: 0)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user4), "😓")

        let user5 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: 20)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user5), "😳")

        let user6 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: 50)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user6), "🤔")

        let user7 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: 100)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user7), "😏")

        let user8 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: 200)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user8), "😇")

        let user9 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: 201)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user9), "🤑")

        let user10 = User(name: "User Name",
                         payday: 10,
                         startDate: Date(),
                         largeTransaction: 10,
                         allowance: Double.nan)

        XCTAssertEqual(spendingBusinessLogic.allowanceIcon(for: user10), "")
    }

}
