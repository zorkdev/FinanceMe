@testable import MyFinanceKit

class BaseViewControllerTests: XCTestCase {
    class TestViewController: BaseViewController {}

    var testViewController: TestViewController?

    override func setUp() {
        super.setUp()

        testViewController = TestViewController()
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = testViewController
        _ = testViewController?.view
    }

    func testViewWillDisappear() {
        testViewController?.viewWillDisappear(true)
    }

    func testPresentAndDismiss() {
        let newExpectation = expectation(description: "Expectation fulfilled")

        let viewController = TestViewController()
        testViewController?.present(viewController: viewController, animated: false)

        XCTAssertTrue(testViewController?.presented is BaseViewController)

        _ = viewController.dismiss()
            .ensure { newExpectation.fulfill() }
            .catch(policy: .allErrors) { error in XCTFail(error.localizedDescription) }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testTextFieldDelegate() {
        XCTAssertTrue(testViewController?.textFieldShouldReturn(UITextField()) == true)
        testViewController?.textFieldDidEndEditing(UITextField())
    }
}
