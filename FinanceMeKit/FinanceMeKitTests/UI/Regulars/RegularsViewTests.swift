import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class RegularsViewTests: XCTestCase {
    func testView() {
        let appState = MockAppState()

        appState.mockTransactionBusinessLogic.transactionsReturnValue = [
            Transaction(id: UUID(),
                        amount: 210.42,
                        direction: .inbound,
                        created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                        narrative: "Transaction",
                        source: .externalRegularInbound),
            Transaction(id: UUID(),
                        amount: -120.12,
                        direction: .outbound,
                        created: ISO8601DateFormatter().date(from: "2019-01-02T00:00:00Z")!,
                        narrative: "Transaction",
                        source: .externalRegularOutbound)
        ]

        assert(view: RegularsView(appState: appState, loadingState: LoadingState(), errorViewModel: ErrorViewModel()),
               previews: RegularsViewPreviews.self)
    }
}
