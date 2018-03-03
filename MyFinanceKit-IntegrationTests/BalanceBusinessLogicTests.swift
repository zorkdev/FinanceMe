@testable import MyFinanceKit

class BalanceBusinessLogicTests: XCTestCase {

    func testGetBalance() {
        print(config)
        let newExpectation = expectation(description: "Balance fetched")

        let balanceBusinessLogic = BalanceBusinessLogic(networkService: appState.networkService,
                                                        dataService: appState.dataService)

        _ = balanceBusinessLogic.getBalance()
            .done { _ in
                newExpectation.fulfill()
            }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
