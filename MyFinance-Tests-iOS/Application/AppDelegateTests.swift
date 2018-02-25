@testable import MyFinance_iOS

class AppDelegateTests: XCTestCase {

    func testLifecycle() {
        let appDelegate = AppDelegate()
        XCTAssertTrue(appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil))
        appDelegate.applicationWillEnterForeground(UIApplication.shared)
        appDelegate.applicationDidEnterBackground(UIApplication.shared)
    }

}
