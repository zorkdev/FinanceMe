@testable import MyFinance_iOS

class AppDelegateTests: XCTestCase {
    func testLifecycle() {
        let newExpectation = expectation(description: "Expectation")

        let mockAppStateiOS = MockAppStateiOS()
        let mockAuthViewModel = MockAuthViewModel()
        let mockNavigator = mockAppStateiOS.navigator as? MockNavigator

        let appDelegate = AppDelegate()
        appDelegate.authViewModel = mockAuthViewModel
        appDelegate.appState = mockAppStateiOS

        XCTAssertTrue(appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil))

        DispatchQueue.main.async {
            XCTAssertTrue(mockNavigator!.didCallCreateNavigationStack)
            XCTAssertNil(mockNavigator!.lastViewModel)
            XCTAssertNotNil(mockNavigator!.lastAuthViewModelType)
            XCTAssertTrue(mockAuthViewModel.didCallAuthenticate)

            appDelegate.applicationWillEnterForeground(UIApplication.shared)
            XCTAssertTrue(mockAuthViewModel.didCallAuthenticate)

            appDelegate.applicationDidEnterBackground(UIApplication.shared)
            XCTAssertTrue(mockAuthViewModel.didCallAddOcclusion)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
