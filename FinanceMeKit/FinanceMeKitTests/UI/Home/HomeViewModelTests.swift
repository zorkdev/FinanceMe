import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class HomeViewModelTests: XCTestCase {
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        viewModel = HomeViewModel(transactionBusinessLogic: transactionBusinessLogic,
                                  summaryBusinessLogic: summaryBusinessLogic)
    }

    func testOnAppear() {
        viewModel.onAppear()

        XCTAssertTrue(transactionBusinessLogic.didCallFetchTransactions)
        XCTAssertTrue(summaryBusinessLogic.didCallFetchSummary)
    }
}
