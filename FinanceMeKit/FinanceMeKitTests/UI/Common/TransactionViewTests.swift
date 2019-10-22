import XCTest
@testable import FinanceMeKit

class TransactionViewTests: XCTestCase {
    func testView() {
        assert(view: TransactionView(narrative: "Test", amount: 10),
               previews: TransactionViewPreviews.self)
        assert(view: TransactionView(narrative: "Test", amount: 10, signs: []),
               previews: TransactionViewPreviews.self)
        assert(view: TransactionView(narrative: "Test", amount: -10, signs: [.minus]),
               previews: TransactionViewPreviews.self)
    }
}
