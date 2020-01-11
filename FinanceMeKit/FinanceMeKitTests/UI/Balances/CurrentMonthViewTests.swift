import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class CurrentMonthViewTests: XCTestCase {
    func testView() {
        assert(view: CurrentMonthView(currentMonth: Summary.stub.currentMonthSummary),
               previews: CurrentMonthViewPreviews.self)
    }
}
