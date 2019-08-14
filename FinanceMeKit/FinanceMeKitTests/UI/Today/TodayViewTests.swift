import XCTest
@testable import FinanceMeKit

class TodayViewTests: XCTestCase {
    func testView() {
        assert(view: TodayView(viewModel: TodayViewPreviews.Stub()), previews: TodayViewPreviews.self)
    }
}
