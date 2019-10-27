import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class HomeViewModelTests: XCTestCase {
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var authenticationBusinessLogic: MockAuthenticationBusinessLogic!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        authenticationBusinessLogic = MockAuthenticationBusinessLogic()
        viewModel = HomeViewModel(transactionBusinessLogic: transactionBusinessLogic,
                                  summaryBusinessLogic: summaryBusinessLogic,
                                  authenticationBusinessLogic: authenticationBusinessLogic)
    }

    func testOnAppear() {
        viewModel.onAppear()

        XCTAssertTrue(transactionBusinessLogic.didCallFetchTransactions)
        XCTAssertTrue(summaryBusinessLogic.didCallFetchSummary)
    }

    func testBindings() {
        XCTAssertFalse(viewModel.isAuthenticated)

        authenticationBusinessLogic.isAuthenticatedReturnValue = true

        waitForEvent {
            XCTAssertTrue(self.viewModel.isAuthenticated)
        }
    }
}
