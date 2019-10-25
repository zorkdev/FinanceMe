import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class RegularsViewModelTests: XCTestCase {
    var businessLogic: MockTransactionBusinessLogic!
    var viewModel: RegularsViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockTransactionBusinessLogic()
        viewModel = RegularsViewModel(businessLogic: businessLogic)
    }

    func testBindings() {
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
                        source: .externalRegularOutbound)
        ]

        businessLogic.transactionsReturnValue = transactions

        waitForEvent {
            XCTAssertEqual(self.viewModel.monthlyBalance.allowance.rounded(scale: 2, mode: .plain), 180.60)
            XCTAssertEqual(self.viewModel.monthlyBalance.outgoings.rounded(scale: 2, mode: .plain), -340.24)
            XCTAssertEqual(self.viewModel.incomingSection.rows, [transactions[1], transactions[0]])
            XCTAssertEqual(self.viewModel.outgoingSection.rows, [transactions[3], transactions[2]])
        }
    }
}
