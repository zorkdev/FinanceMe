@testable import MyFinance_iOS

class SettingsViewControllerTests: XCTestCase {

    var mockSettingsViewModel: MockSettingsViewModel!

    override func setUp() {
        super.setUp()

        mockSettingsViewModel = MockSettingsViewModel()
    }

    func testStatusBarStyle() {
        let settingsViewController = SettingsViewController()
        XCTAssertTrue(settingsViewController.preferredStatusBarStyle == .lightContent)
    }

    func testViewDidLoad() {
        let settingsViewController = SettingsViewController.instantiate()
        settingsViewController.inject(viewModel: mockSettingsViewModel)
        _ = settingsViewController.view
        XCTAssertTrue(mockSettingsViewModel.didCallViewDidLoad)
    }

}
