@testable import MyFinance_iOS

class NavigatorTests: XCTestCase {

    typealias ViewController = UIViewController

    var mockWindow: MockWindow!

    override func setUp() {
        super.setUp()

        mockWindow = MockWindow(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
    }

    func testInit() {
        let navigator = Navigator(window: mockWindow)
        XCTAssertTrue(navigator.window is MockWindow)
    }

    func testCreateNavigationStack() {
        let navigator = Navigator(window: mockWindow)
        let mockLaunchViewModel = MockLaunchViewModel()

        navigator.createNavigationStack(scene: .launch, viewModel: mockLaunchViewModel)

        let launchViewController = mockWindow.baseViewController as? LaunchViewController
        XCTAssertNotNil(launchViewController)
        XCTAssertTrue(launchViewController!.viewModel is MockLaunchViewModel)
        XCTAssertTrue(mockLaunchViewModel.lastInjectValue is LaunchViewController)
        XCTAssertTrue(mockWindow.didCallMakeKeyAndVisible)
    }

    func testCreateAuthStack() {
        let navigator = Navigator(window: mockWindow)
        let mockAuthViewModel = MockAuthViewModel()

        navigator.createAuthStack(viewModel: mockAuthViewModel)

        let authViewController = mockWindow.lastCreateWindow?.baseViewController as? AuthViewController
        XCTAssertEqual(mockWindow.lastCreateWindow!.frame, mockWindow.frame)
        XCTAssertEqual(mockWindow.lastCreateWindow!.windowLevel, UIWindowLevelStatusBar - 1)
        XCTAssertNotNil(authViewController)
        XCTAssertTrue(authViewController!.viewModel is MockAuthViewModel)
        XCTAssertTrue(mockAuthViewModel.lastInjectValue is AuthViewController)
        XCTAssertTrue(mockWindow.lastCreateWindow!.didCallMakeKeyAndVisible)
    }

    func testMoveToAndDismiss() {
        let newExpectation = expectation(description: "View controller dismissed")

        let window = UIWindow()
        let navigator = Navigator(window: window)
        let mockHomeViewModel = MockHomeViewModel()
        let mockSettingsViewModel = MockSettingsViewModel()

        navigator.createNavigationStack(scene: .home, viewModel: mockHomeViewModel)
        navigator.moveTo(scene: .settings, viewModel: mockSettingsViewModel)

        let settingsViewController = window.baseViewController?.presented as? SettingsViewController
        XCTAssertNotNil(settingsViewController)
        XCTAssertTrue(settingsViewController!.viewModel is MockSettingsViewModel)
        XCTAssertTrue(mockSettingsViewModel.lastInjectValue is SettingsViewController)

        _ = navigator.dismiss().done {
            XCTAssertNil(window.baseViewController?.presented)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testPopToRoot() {
        let newExpectation = expectation(description: "Popped to root")

        let appState = MockAppStateiOS()
        let window = UIWindow()
        let navigator = Navigator(window: window)
        navigator.appState = appState
        let mockHomeViewModel = MockHomeViewModel()

        navigator.createNavigationStack(scene: .home, viewModel: mockHomeViewModel)
        navigator.moveTo(scene: .settings, viewModel: nil)

        _ = navigator.popToRoot().done {
            XCTAssertNotNil(window.baseViewController)
            XCTAssertNil(window.baseViewController?.presented)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testShowAndHideAuthWindow() {
        let navigator = Navigator(window: mockWindow)
        let mockAuthViewModel = MockAuthViewModel()

        navigator.createAuthStack(viewModel: mockAuthViewModel)

        let mockAuthWindow = mockWindow.lastCreateWindow!
        XCTAssertTrue(mockAuthWindow.isHidden)

        navigator.showAuthWindow()
        XCTAssertFalse(mockAuthWindow.isHidden)

        navigator.hideAuthWindow()
        XCTAssertTrue(mockAuthWindow.isHidden)
    }

}
