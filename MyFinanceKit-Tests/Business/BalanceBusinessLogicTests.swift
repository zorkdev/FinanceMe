@testable import MyFinanceKit

class BalanceBusinessLogicTests: ServiceClientTestCase {

    func testGetBalance() {
        let newExpectation = expectation(description: "Balance fetched")

        let expectedBalance = Factory.makeBalance()

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedBalance]

        let balanceBusinessLogic = BalanceBusinessLogic(serviceProvider: mockAppState)

        _ = balanceBusinessLogic.getBalance().done { balance in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .starling(.balance))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(balance, expectedBalance)
            XCTAssertTrue(self.mockAppState.mockDataService.savedValues
                .contains(where: { ($0 as? Balance) == expectedBalance }) == true)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
