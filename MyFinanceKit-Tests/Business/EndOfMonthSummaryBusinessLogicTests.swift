@testable import MyFinanceKit

class EndOfMonthSummaryBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()
    var mockDataService = MockDataService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
        mockDataService = MockDataService()
    }

    func testGetEndOfMonthSummaryList() {
        let newExpectation = expectation(description: "EndOfMonthSummaryList fetched")

        let currentMonthSummary = CurrentMonthSummary(allowance: 100,
                                                      forecast: -50.12,
                                                      spending: -10)

        let endOfMonthSummary = EndOfMonthSummary(balance: 100,
                                                  created: Date())

        let expectedEndOfMonthSummaryList = EndOfMonthSummaryList(currentMonthSummary: currentMonthSummary,
                                                                  endOfMonthSummaries: [endOfMonthSummary])

        mockNetworkService.returnJSONDecodableValue = expectedEndOfMonthSummaryList

        let endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic(networkService: mockNetworkService)

        _ = endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList().done { endOfMonthSummaryList in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.endOfMonthSummaries))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(endOfMonthSummaryList, expectedEndOfMonthSummaryList)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
