@testable import MyFinanceKit

class EndOfMonthSummaryBusinessLogicTests: XCTestCase {

    func testGetEndOfMonthSummaryList() {
        let newExpectation = expectation(description: "EndOfMonthSummaryList fetched")

        let endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic()

        _ = endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList()
            .done { endOfMonthSummaryList in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
