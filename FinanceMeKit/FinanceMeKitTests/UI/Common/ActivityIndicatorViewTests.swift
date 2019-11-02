import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class ActivityIndicatorViewTests: XCTestCase {
    func testView() {
        assert(view: ActivityIndicatorView(style: .medium))
        assert(view: ActivityIndicatorView(style: .large))
    }
}
