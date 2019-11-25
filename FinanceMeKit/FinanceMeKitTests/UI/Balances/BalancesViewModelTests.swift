import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class BalancesViewModelTests: XCTestCase {
    var businessLogic: MockSummaryBusinessLogic!
    var viewModel: BalancesViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockSummaryBusinessLogic()
        viewModel = BalancesViewModel(businessLogic: businessLogic)
    }

    func testBindings() {
        businessLogic.summaryReturnValue = Summary.stub

        waitForEvent {
            XCTAssertEqual(self.viewModel.currentMonth, Summary.stub.currentMonthSummary)
            XCTAssertEqual(self.viewModel.summarySections.first?.rows,
                           [EndOfMonthSummaryViewModel(summary: Summary.stub.endOfMonthSummaries[1])])
            XCTAssertEqual(self.viewModel.summarySections.last?.rows,
                           [EndOfMonthSummaryViewModel(summary: Summary.stub.endOfMonthSummaries[0])])
        }
    }
}
