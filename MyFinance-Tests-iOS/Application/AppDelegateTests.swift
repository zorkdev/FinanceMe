@testable import MyFinance_iOS

class AppDelegateTests: XCTestCase {

    func testLifecycle() {
        let mockAppStateiOS = MockAppStateiOS()
        let mockAuthViewModel = MockAuthViewModel()
        let mockNavigator = mockAppStateiOS.navigator as? MockNavigator

        let appDelegate = AppDelegate()
        appDelegate.authViewModel = mockAuthViewModel
        appDelegate.appState = mockAppStateiOS

        XCTAssertTrue(appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil))
        XCTAssertTrue(mockNavigator!.didCallCreateNavigationStack)
        XCTAssertTrue(mockNavigator!.lastViewModel is HomeViewModelType)
        XCTAssertNotNil(mockNavigator!.lastAuthViewModelType)
        XCTAssertTrue(mockAuthViewModel.didCallAuthenticate)

        appDelegate.applicationWillEnterForeground(UIApplication.shared)
        XCTAssertTrue(mockAuthViewModel.didCallAuthenticate)

        appDelegate.applicationDidEnterBackground(UIApplication.shared)
        XCTAssertTrue(mockAuthViewModel.didCallAddOcclusion)
    }

}
