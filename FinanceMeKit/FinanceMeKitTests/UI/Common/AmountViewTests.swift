import XCTest
@testable import FinanceMeKit

final class AmountViewTests: XCTestCase {
    func testView() {
        assert(view: AmountView(viewModel: AmountViewModel(value: 1)), previews: AmountViewPreviews.self)
    }
}
