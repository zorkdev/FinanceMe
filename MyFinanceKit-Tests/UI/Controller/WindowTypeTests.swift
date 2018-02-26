@testable import MyFinanceKit

class UIWindowTests: XCTestCase {

    func testCreateWindow() {
        let expectedFrame = CGRect(x: 0, y: 0, width: 10, height: 20)
        let window = UIWindow()
        let newWindow = window.createWindow(frame: expectedFrame)
        XCTAssertEqual(newWindow.frame, expectedFrame)
    }

    func testBaseViewController() {
        let viewController = BaseViewController()
        let window = UIWindow()
        window.baseViewController = viewController
        XCTAssertEqual(window.baseViewController as? BaseViewController, viewController)
    }

}
