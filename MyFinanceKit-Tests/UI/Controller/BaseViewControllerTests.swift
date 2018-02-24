@testable import MyFinanceKit

class BaseViewControllerTests: XCTestCase {

    var baseViewController: BaseViewController?

    override func setUp() {
        super.setUp()

        baseViewController = BaseViewController()
        UIApplication.shared.keyWindow?.rootViewController = baseViewController
        _ = baseViewController?.view
    }

    func testViewWillDisappear() {
        baseViewController?.viewWillDisappear(true)
    }

    func testDismiss() {
        baseViewController?.dismiss(self)
    }

    func testTextFieldDelegate() {
        XCTAssertTrue(baseViewController?.textFieldShouldReturn(UITextField()) == true)
        baseViewController?.textFieldDidEndEditing(UITextField())
    }

}
