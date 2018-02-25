@testable import MyFinance_iOS

class MessagePresentableTests: XCTestCase {

    let viewController = BaseViewController()

    func testShowError() {
        viewController.showError(message: "Error")
    }

    func testShowSuccess() {
        viewController.showSuccess(message: "Success")
    }

    func testSpinner() {
        viewController.showSpinner()
        viewController.hideSpinner()
    }

}
