import XCTest
@testable import FinanceMeKit

class VerticalTodayViewTests: XCTestCase {
    func testView() {
        assert(view: VerticalTodayView(viewModel: Stub.StubTodayViewModel()),
               previews: VerticalTodayViewPreviews.self)
    }
}
