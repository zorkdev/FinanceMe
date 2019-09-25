import XCTest
@testable import FinanceMeKit

class TodayViewTests: XCTestCase {
    func testView() {
        assert(view: TodayView(viewModel: Stub.StubTodayViewModel()), previews: TodayViewPreviews.self)
    }
}
