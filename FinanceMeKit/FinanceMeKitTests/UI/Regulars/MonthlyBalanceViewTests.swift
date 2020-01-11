import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class MonthlyBalanceViewTests: XCTestCase {
    func testView() {
        assert(view: MonthlyBalanceView(monthlyBalance: RegularsViewModel.MonthlyBalance(allowance: 10, outgoings: -20)),
               previews: MonthlyBalanceViewPreviews.self)
    }
}
