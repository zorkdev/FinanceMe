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

    func testPresent() {
        let viewController = BaseViewController()
        baseViewController?.present(viewController: viewController)
    }

    func testDismiss() {
        _ = baseViewController?.dismiss()
    }

    func testTextFieldDelegate() {
        XCTAssertTrue(baseViewController?.textFieldShouldReturn(UITextField()) == true)
        baseViewController?.textFieldDidEndEditing(UITextField())
    }

}
