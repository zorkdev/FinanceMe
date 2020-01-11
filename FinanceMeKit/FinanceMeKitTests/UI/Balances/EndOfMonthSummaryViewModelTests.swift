import XCTest
@testable import FinanceMeKit

final class EndOfMonthSummaryViewModelTests: XCTestCase {
    func testViewModel() {
        let summary = Summary.stub.endOfMonthSummaries[0]
        let viewModel = EndOfMonthSummaryViewModel(summary: summary)

        XCTAssertEqual(viewModel.narrative, "January")
        XCTAssertEqual(viewModel.balanceViewModel.value, summary.balance)
        XCTAssertEqual(viewModel.savingsViewModel.value, summary.savings)
        XCTAssertEqual(viewModel.id, summary.created)
    }
}
