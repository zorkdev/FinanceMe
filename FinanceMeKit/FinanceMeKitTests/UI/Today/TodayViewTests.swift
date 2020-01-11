import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class TodayViewTests: XCTestCase {
    func testView() {
        assert(view: TodayView(appState: MockAppState()), previews: TodayViewPreviews.self)
    }
}
