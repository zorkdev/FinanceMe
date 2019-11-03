import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class HomeViewModelTests: XCTestCase {
    var userBusinessLogic: MockUserBusinessLogic!
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var errorViewModel: ErrorViewModel!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        userBusinessLogic = MockUserBusinessLogic()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        errorViewModel = ErrorViewModel()
        viewModel = HomeViewModel(loadingState: LoadingState(),
                                  errorViewModel: errorViewModel,
                                  userBusinessLogic: userBusinessLogic,
                                  transactionBusinessLogic: transactionBusinessLogic,
                                  summaryBusinessLogic: summaryBusinessLogic)
    }

    func testOnAppear() {
        viewModel.onAppear()

        XCTAssertTrue(transactionBusinessLogic.didCallFetchTransactions)
        XCTAssertTrue(summaryBusinessLogic.didCallFetchSummary)
    }

    func testOnRefresh_Success() {
        userBusinessLogic.getUserReturnValue = .success(())
        transactionBusinessLogic.getTransactionsReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .success(())

        viewModel.onRefresh()

        waitForEvent {}

        XCTAssertTrue(userBusinessLogic.didCallGetUser)
        XCTAssertTrue(transactionBusinessLogic.didCallGetTransactions)
        XCTAssertTrue(summaryBusinessLogic.didCallGetSummary)
    }

    func testOnRefresh_Failure() {
        userBusinessLogic.getUserReturnValue = .success(())
        transactionBusinessLogic.getTransactionsReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .failure(TestError())

        viewModel.onRefresh()

        waitForEvent {}

        XCTAssertTrue(errorViewModel.error is TestError)
    }
}
