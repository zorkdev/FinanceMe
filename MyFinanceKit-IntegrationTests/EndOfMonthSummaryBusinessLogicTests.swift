@testable import MyFinanceKit

class EndOfMonthSummaryBusinessLogicTests: XCTestCase {

    func testGetEndOfMonthSummaryList() {
        let newExpectation = expectation(description: "EndOfMonthSummaryList fetched")

        let endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic(networkService: appState.networkService)

        _ = endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList()
            .done { _ in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
