@testable import MyFinanceKit

class BaseViewControllerTests: XCTestCase {

    var baseViewController: BaseViewController?

    override func setUp() {
        super.setUp()

        baseViewController = BaseViewController()
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = baseViewController
        _ = baseViewController?.view
    }

    func testViewWillDisappear() {
        baseViewController?.viewWillDisappear(true)
    }

    func testPresentAndDismiss() {
        let newExpectation = expectation(description: "Expectation fulfilled")

        let viewController = BaseViewController()
        baseViewController?.present(viewController: viewController, animated: false)

        XCTAssertTrue(baseViewController?.presented is BaseViewController)

        _ = viewController.dismiss()
            .ensure { newExpectation.fulfill() }
            .catch(policy: .allErrors) { error in XCTFail(error.localizedDescription) }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testTextFieldDelegate() {
        XCTAssertTrue(baseViewController?.textFieldShouldReturn(UITextField()) == true)
        baseViewController?.textFieldDidEndEditing(UITextField())
    }

    func testKeyboardChanged() {
        let textField = UITextField()
        baseViewController?.view.addSubview(textField)
        textField.becomeFirstResponder()
    }
}
