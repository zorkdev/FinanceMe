@testable import MyFinanceKit

class EndOfMonthSummaryBusinessLogicTests: IntegrationTestCase {

    func testGetEndOfMonthSummaryList() {
        let newExpectation = expectation(description: "EndOfMonthSummaryList fetched")

        let endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic(serviceProvider: config.appState)

        _ = endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList()
            .done { _ in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
