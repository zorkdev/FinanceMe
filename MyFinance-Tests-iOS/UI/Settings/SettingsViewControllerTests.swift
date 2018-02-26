@testable import MyFinance_iOS

class SettingsViewControllerTests: XCTestCase {

    func testViewDidLoad() {
        let settingsViewController = SettingsViewController.instantiate()
        settingsViewController.inject(viewModel: MockSettingsViewModel())
        _ = settingsViewController.view
    }

}
