@testable import MyFinanceKit

class EndOfMonthSummaryBusinessLogicTests: ServiceClientTestCase {

    func testGetEndOfMonthSummaryList() {
        let newExpectation = expectation(description: "EndOfMonthSummaryList fetched")

        let currentMonthSummary = CurrentMonthSummary(allowance: 100,
                                                      forecast: -50.12,
                                                      spending: -10)

        let endOfMonthSummary = EndOfMonthSummary(balance: 100,
                                                  created: Date())

        let expectedEndOfMonthSummaryList = EndOfMonthSummaryList(currentMonthSummary: currentMonthSummary,
                                                                  endOfMonthSummaries: [endOfMonthSummary])

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedEndOfMonthSummaryList]

        let endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic(serviceProvider: mockAppState)

        _ = endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList().done { endOfMonthSummaryList in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API,
                           .zorkdev(.endOfMonthSummaries))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(endOfMonthSummaryList, expectedEndOfMonthSummaryList)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
