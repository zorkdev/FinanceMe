import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class FeedViewModelTests: XCTestCase {
    var businessLogic: MockTransactionBusinessLogic!
    var viewModel: FeedViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockTransactionBusinessLogic()
        viewModel = FeedViewModel(businessLogic: businessLogic)
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

        businessLogic.transactionsReturnValue = transactions

        waitForEvent {
            XCTAssertEqual(self.viewModel.sections.count, 2)
            XCTAssertEqual(self.viewModel.sections.first?.rows.count, 1)
            XCTAssertEqual(self.viewModel.sections.last?.rows.count, 1)
            XCTAssertEqual(self.viewModel.sections.first?.rows.first, transactions.last)
            XCTAssertEqual(self.viewModel.sections.last?.rows.first, transactions.first)
        }
    }
}
