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

        let expectedBalance = Factory.makeBalance()

        mockNetworkService.returnJSONDecodableValues = [expectedBalance]

        let balanceBusinessLogic = BalanceBusinessLogic(networkService: mockNetworkService,
                                                        dataService: mockDataService)

        _ = balanceBusinessLogic.getBalance().done { balance in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .starling(.balance))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(balance, expectedBalance)
            XCTAssertTrue(self.mockDataService.savedValues
                .contains(where: { ($0 as? Balance) == expectedBalance }) == true)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
