@testable import MyFinanceKit

class BalanceBusinessLogicTests: XCTestCase {

    func testGetBalance() {
        let newExpectation = expectation(description: "Balance fetched")

        let balanceBusinessLogic = BalanceBusinessLogic()

        _ = balanceBusinessLogic.getBalance()
            .done { _ in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
