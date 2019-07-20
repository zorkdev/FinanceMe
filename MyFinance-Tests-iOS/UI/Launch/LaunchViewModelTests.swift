@testable import MyFinance_iOS

class LaunchViewModelTests: ServiceClientiOSTestCase {
    var launchViewModel: LaunchViewModel!

    override func setUp() {
        super.setUp()

        launchViewModel = LaunchViewModel(serviceProvider: mockAppState)
    }

    func testInject() {
        launchViewModel.inject(delegate: MockSettingsViewModelDelegate())
    }

    func testViewDidAppearWithSession() {
        mockAppState.mockSessionService.hasSessionReturnValue = true

        launchViewModel.viewDidAppear()

        XCTAssertEqual(mockAppState.mockNavigator.lastMoveToValue?.scene, .home)
        XCTAssertNil(mockAppState.mockNavigator.lastMoveToValue?.viewModel)
    }

    func testViewDidAppearWithoutSession() {
        mockAppState.mockSessionService.hasSessionReturnValue = false

        launchViewModel.viewDidAppear()

        XCTAssertEqual(mockAppState.mockNavigator.lastMoveToValue?.scene, .login)
        XCTAssertNil(mockAppState.mockNavigator.lastMoveToValue?.viewModel)
    }
}
