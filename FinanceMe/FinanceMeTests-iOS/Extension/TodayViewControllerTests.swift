import XCTest
import FinanceMeTestKit
@testable import FinanceMeExtension

class TodayViewControllerTests: XCTestCase {
    func testView() {
        let viewController = TodayViewController()

        waitUntil { done in
            viewController.widgetPerformUpdate { _ in
                done()
            }
        }
    }
}
