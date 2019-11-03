import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class TransactionDetailViewModelTests: XCTestCase {
    var userBusinessLogic: MockUserBusinessLogic!
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var errorViewModel: ErrorViewModel!
    var viewModel: TransactionDetailViewModel!

    override func setUp() {
        super.setUp()
        userBusinessLogic = MockUserBusinessLogic()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        errorViewModel = ErrorViewModel()
        viewModel = TransactionDetailViewModel(transaction: Transaction.stub,
                                               loadingState: LoadingState(),
                                               errorViewModel: errorViewModel,
                                               userBusinessLogic: userBusinessLogic,
                                               transactionBusinessLogic: transactionBusinessLogic,
                                               summaryBusinessLogic: summaryBusinessLogic)
    }

    func testWithTransaction() {
        transactionBusinessLogic.updateReturnValue = .success(())
        userBusinessLogic.getUserReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .success(())

        XCTAssertEqual(viewModel.amount, "£110.42")
        XCTAssertEqual(viewModel.narrative, Transaction.stub.narrative)
        XCTAssertEqual(viewModel.category, Transaction.stub.source)
        XCTAssertEqual(viewModel.date, Transaction.stub.created)
        XCTAssertTrue(viewModel.isDisabled)

        viewModel.narrative = "Test Narrative"
        waitForEvent {}

        XCTAssertFalse(viewModel.isDisabled)

        viewModel.amount = "lkj"
        viewModel.onAmountEditingChanged(isEditing: false)
        waitForEvent {}

        XCTAssertEqual(viewModel.amount, "")

        viewModel.amount = "23"
        viewModel.onAmountEditingChanged(isEditing: false)
        waitForEvent {}

        XCTAssertEqual(viewModel.amount, "£23.00")

        viewModel.onSave()
        waitForEvent {}

        XCTAssertEqual(transactionBusinessLogic.lastUpdateParam,
                       Transaction(id: Transaction.stub.id,
                                   amount: -23,
                                   direction: Transaction.stub.direction,
                                   created: Transaction.stub.created,
                                   narrative: "Test Narrative",
                                   source: Transaction.stub.source))

        XCTAssertTrue(userBusinessLogic.didCallGetUser)
        XCTAssertTrue(summaryBusinessLogic.didCallGetSummary)
        XCTAssertTrue(viewModel.shouldDismiss)
    }

    func testWithoutTransaction() {
        let date = Date()
        transactionBusinessLogic.createReturnValue = .success(())
        userBusinessLogic.getUserReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .success(())

        viewModel = TransactionDetailViewModel(transaction: nil,
                                               loadingState: LoadingState(),
                                               errorViewModel: errorViewModel,
                                               userBusinessLogic: userBusinessLogic,
                                               transactionBusinessLogic: transactionBusinessLogic,
                                               summaryBusinessLogic: summaryBusinessLogic)

        XCTAssertEqual(viewModel.amount, "")
        XCTAssertEqual(viewModel.narrative, "")
        XCTAssertEqual(viewModel.category, Transaction.Source.externalOutbound)
        XCTAssertTrue(viewModel.isDisabled)

        viewModel.amount = "12"
        viewModel.narrative = "Test Narrative"
        viewModel.category = .externalRegularInbound
        viewModel.date = date
        viewModel.onAmountEditingChanged(isEditing: true)
        waitForEvent {}

        XCTAssertFalse(viewModel.isDisabled)

        viewModel.onSave()
        waitForEvent {}

        XCTAssertEqual(transactionBusinessLogic.lastCreateParam,
                       Transaction(id: transactionBusinessLogic.lastCreateParam!.id,
                                   amount: 12,
                                   direction: Transaction.Direction.inbound,
                                   created: date,
                                   narrative: "Test Narrative",
                                   source: Transaction.Source.externalRegularInbound))

        XCTAssertTrue(userBusinessLogic.didCallGetUser)
        XCTAssertTrue(summaryBusinessLogic.didCallGetSummary)
    }

    func testOnSave_Failure() {
        transactionBusinessLogic.updateReturnValue = .failure(TestError())

        viewModel.narrative = "Test Narrative"
        waitForEvent {}

        viewModel.onSave()
        waitForEvent {}

        XCTAssertTrue(errorViewModel.error is TestError)
    }
}
