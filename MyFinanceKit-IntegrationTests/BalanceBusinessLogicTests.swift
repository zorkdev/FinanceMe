@testable import MyFinanceKit

class BalanceBusinessLogicTests: XCTestCase {

    func testGetBalance() {
        let newExpectation = expectation(description: "Balance fetched")

        let balanceBusinessLogic = BalanceBusinessLogic()

        _ = balanceBusinessLogic.getBalance()
            .done { balance in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
