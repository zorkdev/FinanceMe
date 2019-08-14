import XCTest
import UIKit
import FinanceMeTestKit
@testable import FinanceMeExtension

class TodayViewControllerTests: XCTestCase {
    func testView() {
        assert(view: TodayContentView(viewModel: TodayContentViewPreviews.Stub()), previews: TodayContentViewPreviews.self)
        XCTAssertNil(TodayViewController(coder: NSCoder()))
        let viewController = TodayViewController(nibName: nil, bundle: nil)

        waitUntil { done in
            viewController.widgetPerformUpdate { _ in
                done()
            }
        }
    }
}
