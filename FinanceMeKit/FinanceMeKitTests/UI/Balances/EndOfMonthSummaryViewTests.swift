import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class EndOfMonthSummaryViewTests: XCTestCase {
    func testView() {
        assert(view: EndOfMonthSummaryView(viewModel:
            EndOfMonthSummaryViewModel(summary: Summary.stub.endOfMonthSummaries[0])),
               previews: EndOfMonthSummaryViewPreviews.self)
    }
}
