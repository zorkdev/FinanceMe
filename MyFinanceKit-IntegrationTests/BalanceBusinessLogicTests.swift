@testable import MyFinanceKit

class BalanceBusinessLogicTests: IntegrationTestCase {

    func testGetBalance() {
        let newExpectation = expectation(description: "Balance fetched")

        let balanceBusinessLogic = BalanceBusinessLogic(serviceProvider: config.appState)

        _ = balanceBusinessLogic.getBalance()
            .done { _ in
                newExpectation.fulfill()
            }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
