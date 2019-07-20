@testable import MyFinance_iOS

class LaunchViewControllerTests: XCTestCase {
    var mockLaunchViewModel: MockLaunchViewModel!
    var launchViewController: LaunchViewController!

    override func setUp() {
        super.setUp()

        mockLaunchViewModel = MockLaunchViewModel()
        launchViewController = LaunchViewController()
    }

    func testInject() {
        launchViewController.inject(viewModel: mockLaunchViewModel)
        XCTAssertTrue(launchViewController.viewModel is MockLaunchViewModel)
    }

    func testViewDidAppear() {
        launchViewController.inject(viewModel: mockLaunchViewModel)
        launchViewController.viewDidAppear(true)
        XCTAssertTrue(mockLaunchViewModel.didCallViewDidAppear)
    }
}
