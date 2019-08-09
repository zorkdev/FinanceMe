import XCTest
import UIKit
import FinanceMeTestKit
@testable import FinanceMeExtension

class TodayViewControllerTests: XCTestCase {
    func testView() {
        XCTAssertNil(TodayViewController(coder: NSCoder()))
        let viewController = TodayViewController(nibName: nil, bundle: nil)

        waitUntil { done in
            viewController.widgetPerformUpdate { _ in
                done()
            }
        }
    }
}
