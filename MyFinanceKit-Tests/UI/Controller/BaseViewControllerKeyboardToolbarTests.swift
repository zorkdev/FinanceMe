@testable import MyFinanceKit

class BaseViewControllerKeyboardToolbarTests: XCTestCase {

    class TestViewController: BaseViewController, KeyboardManageable {}

    var testViewController: TestViewController?

    override func setUp() {
        super.setUp()

        testViewController = TestViewController()
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = testViewController
        _ = testViewController?.view
    }

    func testKeyboardChanged() {
        let textField = UITextField()
        testViewController?.view.addSubview(textField)
        textField.becomeFirstResponder()
    }

    func testKeyboardToolbar() {
        XCTAssertNotNil(testViewController?.keyBoardToolbar)
    }

    func testDoneTapped() {
        testViewController?.doneTapped()
    }

}
