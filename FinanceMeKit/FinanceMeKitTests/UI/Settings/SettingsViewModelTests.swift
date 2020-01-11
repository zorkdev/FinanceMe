import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class SettingsViewModelTests: XCTestCase {
    var sessionBusinessLogic: MockSessionBusinessLogic!
    var userBusinessLogic: MockUserBusinessLogic!
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var errorViewModel: ErrorViewModel!
    var viewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()
        sessionBusinessLogic = MockSessionBusinessLogic()
        userBusinessLogic = MockUserBusinessLogic()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        errorViewModel = ErrorViewModel()
        viewModel = SettingsViewModel(sessionBusinessLogic: sessionBusinessLogic,
                                      userBusinessLogic: userBusinessLogic,
                                      transactionBusinessLogic: transactionBusinessLogic,
                                      summaryBusinessLogic: summaryBusinessLogic,
                                      loadingState: LoadingState(),
                                      errorViewModel: errorViewModel)
    }

    func testIsEditing() {
        userBusinessLogic.userReturnValue = User.stub
        waitForEvent {}

        XCTAssertEqual(viewModel.name, User.stub.name)

        viewModel.isEditing = true
        viewModel.name = "Test Name"
        waitForEvent {}

        viewModel.isEditing = false
        waitForEvent {}

        XCTAssertEqual(viewModel.name, User.stub.name)
    }

    func testSave_Success() {
        userBusinessLogic.userReturnValue = User.stub
        userBusinessLogic.updateReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .success(())
        waitForEvent {}

        XCTAssertEqual(viewModel.name, User.stub.name)
        XCTAssertEqual(viewModel.limit, "£10.00")
        XCTAssertEqual(viewModel.payday, User.stub.payday)
        XCTAssertEqual(viewModel.date, User.stub.startDate)
        XCTAssertTrue(viewModel.isDisabled)

        viewModel.isEditing = true
        viewModel.name = "Test Name"
        waitForEvent {}

        XCTAssertFalse(viewModel.isDisabled)

        viewModel.limit = "lkj"
        viewModel.onLimitEditingChanged(isEditing: false)
        waitForEvent {}

        XCTAssertEqual(viewModel.limit, "")

        viewModel.limit = "23"
        viewModel.onLimitEditingChanged(isEditing: false)
        waitForEvent {}

        XCTAssertEqual(viewModel.limit, "£23.00")

        viewModel.onSave()
        waitForEvent {}

        XCTAssertEqual(userBusinessLogic.lastUpdateParam,
                       User(name: "Test Name",
                            payday: User.stub.payday,
                            startDate: User.stub.startDate,
                            largeTransaction: 23,
                            allowance: User.stub.allowance,
                            balance: User.stub.balance))

        XCTAssertTrue(summaryBusinessLogic.didCallGetSummary)
        XCTAssertTrue(viewModel.shouldDismiss)
    }

    func testSave_Failure() {
        userBusinessLogic.userReturnValue = User.stub
        userBusinessLogic.updateReturnValue = .failure(TestError())
        waitForEvent {}

        viewModel.name = "Test Name"
        waitForEvent {}

        viewModel.onSave()
        waitForEvent {}

        XCTAssertTrue(errorViewModel.error is TestError)
    }

    func testReconcile_Success() {
        transactionBusinessLogic.reconcileReturnValue = .success(())

        viewModel.onReconcile()

        waitForEvent {}

        XCTAssertTrue(transactionBusinessLogic.didCallReconcile)
    }

    func testReconcile_Failure() {
        transactionBusinessLogic.reconcileReturnValue = .failure(TestError())

        viewModel.onReconcile()

        waitForEvent {}

        XCTAssertTrue(errorViewModel.error is TestError)
    }

    func testLogOut() {
        viewModel.onLogOut()

        XCTAssertTrue(sessionBusinessLogic.didCallLogOut)
    }
}
