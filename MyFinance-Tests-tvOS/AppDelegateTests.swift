import XCTest
@testable import MyFinance_tvOS

class AppDelegateTests: XCTestCase {

    func testDidFinishLaunching() {
        let appDelegate = AppDelegate()
        _ = appDelegate.application(UIApplication.shared,
                                    didFinishLaunchingWithOptions: nil)
    }

}
