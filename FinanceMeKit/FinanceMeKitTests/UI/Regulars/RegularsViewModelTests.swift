import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class RegularsViewModelTests: XCTestCase {
    var userBusinessLogic: MockUserBusinessLogic!
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var errorViewModel: ErrorViewModel!
    var viewModel: RegularsViewModel!

    let transactions = [
        Transaction(id: UUID(),
                    amount: 210.42,
                    direction: .inbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalRegularInbound),
        Transaction(id: UUID(),
                    amount: 310.42,
                    direction: .inbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalRegularInbound),
        Transaction(id: UUID(),
                    amount: -120.12,
                    direction: .outbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-02T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalRegularOutbound),
        Transaction(id: UUID(),
                    amount: -220.12,
                    direction: .outbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-02T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalRegularOutbound),
        Transaction(id: UUID(),
                    amount: -50.12,
                    direction: .outbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-03T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalSavings),
        Transaction(id: UUID(),
                    amount: -100.45,
                    direction: .outbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-04T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalSavings)
    ]

    override func setUp() {
        super.setUp()
        userBusinessLogic = MockUserBusinessLogic()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        errorViewModel = ErrorViewModel()
        viewModel = RegularsViewModel(loadingState: LoadingState(),
                                      errorViewModel: errorViewModel,
                                      userBusinessLogic: userBusinessLogic,
                                      transactionBusinessLogic: transactionBusinessLogic,
                                      summaryBusinessLogic: summaryBusinessLogic)
    }

    func testBindings() {
        transactionBusinessLogic.transactionsReturnValue = transactions

        waitForEvent {
            XCTAssertEqual(self.viewModel.monthlyBalance.allowance.rounded(scale: 2, mode: .plain), 180.60)
            XCTAssertEqual(self.viewModel.monthlyBalance.outgoings.rounded(scale: 2, mode: .plain), -340.24)
            XCTAssertEqual(self.viewModel.savingsSection.rows, [self.transactions[5], self.transactions[4]])
            XCTAssertEqual(self.viewModel.incomingSection.rows, [self.transactions[1], self.transactions[0]])
            XCTAssertEqual(self.viewModel.outgoingSection.rows, [self.transactions[3], self.transactions[2]])
        }
    }

    func testOnDelete_Success() {
        let transaction = Transaction(id: UUID(),
                                      amount: 210.42,
                                      direction: .inbound,
                                      created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                                      narrative: "Transaction",
                                      source: .externalRegularInbound)

        transactionBusinessLogic.transactionsReturnValue = [transaction]
        transactionBusinessLogic.deleteReturnValue = .success(())
        userBusinessLogic.getUserReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .success(())

        waitForEvent {}

        viewModel.onDelete(section: viewModel.incomingSection, row: IndexSet(integer: 0))

        waitForEvent {}

        XCTAssertEqual(transactionBusinessLogic.lastDeleteParam, transaction)
        XCTAssertTrue(userBusinessLogic.didCallGetUser)
        XCTAssertTrue(summaryBusinessLogic.didCallGetSummary)
    }

    func testOnDelete_Failure() {
        let transaction = Transaction(id: UUID(),
                                      amount: 210.42,
                                      direction: .inbound,
                                      created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                                      narrative: "Transaction",
                                      source: .externalRegularInbound)

        transactionBusinessLogic.transactionsReturnValue = [transaction]
        transactionBusinessLogic.deleteReturnValue = .failure(TestError())

        waitForEvent {}

        viewModel.onDelete(section: viewModel.incomingSection, row: IndexSet(integer: 0))

        waitForEvent {}

        XCTAssertTrue(errorViewModel.error is TestError)
    }
}
