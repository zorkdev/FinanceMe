@testable import MyFinanceKit

class BalanceBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()
    var mockDataService = MockDataService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
        mockDataService = MockDataService()
    }

    func testGetBalance() {
        let newExpectation = expectation(description: "Balance fetched")

        let expectedBalance = Balance(clearedBalance: 100,
                                      effectiveBalance: 20,
                                      pendingTransactions: 90.22,
                                      availableToSpend: 100,
                                      acceptedOverdraft: 100,
                                      currency: "GBP",
                                      amount: 100)

        mockNetworkService.returnJSONDecodableValue = expectedBalance

        let balanceBusinessLogic = BalanceBusinessLogic(networkService: mockNetworkService,
                                                        dataService: mockDataService)

        _ = balanceBusinessLogic.getBalance().done { balance in

            //XCTAssertEqual(mockNetworkService.lastRequest?.api, StarlingAPI.balance)

            XCTAssertEqual(balance.clearedBalance, expectedBalance.clearedBalance)
            XCTAssertEqual(balance.effectiveBalance, expectedBalance.effectiveBalance)
            XCTAssertEqual(balance.pendingTransactions, expectedBalance.pendingTransactions)
            XCTAssertEqual(balance.availableToSpend, expectedBalance.availableToSpend)
            XCTAssertEqual(balance.acceptedOverdraft, expectedBalance.acceptedOverdraft)
            XCTAssertEqual(balance.currency, expectedBalance.currency)
            XCTAssertEqual(balance.amount, expectedBalance.amount)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
