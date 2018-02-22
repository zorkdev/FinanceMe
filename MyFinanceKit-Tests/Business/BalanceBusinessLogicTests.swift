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

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .starling(.balance))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(balance, expectedBalance)
            XCTAssertEqual(self.mockDataService.lastSavedValue as? Balance, expectedBalance)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
