import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class FeedViewModelTests: XCTestCase {
    var userBusinessLogic: MockUserBusinessLogic!
    var transactionBusinessLogic: MockTransactionBusinessLogic!
    var summaryBusinessLogic: MockSummaryBusinessLogic!
    var viewModel: FeedViewModel!

    override func setUp() {
        super.setUp()
        userBusinessLogic = MockUserBusinessLogic()
        transactionBusinessLogic = MockTransactionBusinessLogic()
        summaryBusinessLogic = MockSummaryBusinessLogic()
        viewModel = FeedViewModel(userBusinessLogic: userBusinessLogic,
                                  transactionBusinessLogic: transactionBusinessLogic,
                                  summaryBusinessLogic: summaryBusinessLogic)
    }

    func testBindings() {
        let transactions = [
            Transaction(id: UUID(),
                        amount: 110.42,
                        direction: .outbound,
                        created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                        narrative: "Transaction",
                        source: .externalOutbound),
            Transaction(id: UUID(),
                        amount: 110.42,
                        direction: .outbound,
                        created: ISO8601DateFormatter().date(from: "2019-01-02T00:00:00Z")!,
                        narrative: "Transaction",
                        source: .externalOutbound)
        ]

        transactionBusinessLogic.transactionsReturnValue = transactions

        waitForEvent {
            XCTAssertEqual(self.viewModel.sections.count, 2)
            XCTAssertEqual(self.viewModel.sections.first?.rows.count, 1)
            XCTAssertEqual(self.viewModel.sections.last?.rows.count, 1)
            XCTAssertEqual(self.viewModel.sections.first?.rows.first, transactions.last)
            XCTAssertEqual(self.viewModel.sections.last?.rows.first, transactions.first)
        }
    }

    func testOnDelete() {
        let transaction = Transaction(id: UUID(),
                                      amount: 110.42,
                                      direction: .outbound,
                                      created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                                      narrative: "Transaction",
                                      source: .externalOutbound)

        transactionBusinessLogic.transactionsReturnValue = [transaction]
        transactionBusinessLogic.deleteReturnValue = .success(())
        userBusinessLogic.getUserReturnValue = .success(())
        summaryBusinessLogic.getSummaryReturnValue = .success(())

        waitForEvent {}

        viewModel.onDelete(section: viewModel.sections[0], row: IndexSet(integer: 0))

        waitForEvent {}

        XCTAssertEqual(transactionBusinessLogic.lastDeleteParam, transaction)
        XCTAssertTrue(userBusinessLogic.didCallGetUser)
        XCTAssertTrue(summaryBusinessLogic.didCallGetSummary)
    }
}
