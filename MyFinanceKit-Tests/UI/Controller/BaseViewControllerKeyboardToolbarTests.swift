@testable import MyFinanceKit

class BaseViewControllerKeyboardToolbarTests: XCTestCase {

    var baseViewController: BaseViewController?

    override func setUp() {
        super.setUp()

        baseViewController = BaseViewController()
        UIApplication.shared.keyWindow?.rootViewController = baseViewController
        _ = baseViewController?.view
    }

    func testKeyboardToolbar() {
        XCTAssertNotNil(baseViewController?.keyBoardToolbar)
    }

    func testDoneTapped() {
        baseViewController?.doneTapped()
    }

}
