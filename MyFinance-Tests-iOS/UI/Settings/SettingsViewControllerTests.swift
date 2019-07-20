@testable import MyFinance_iOS

class SettingsViewControllerTests: XCTestCase {
    var mockSettingsViewModel: MockSettingsViewModel!
    var settingsViewController: SettingsViewController!

    override func setUp() {
        super.setUp()

        mockSettingsViewModel = MockSettingsViewModel()
        settingsViewController = SettingsViewController.instantiate()
        settingsViewController.inject(viewModel: mockSettingsViewModel)
        _ = settingsViewController.view
    }

    func testProperties() {
        XCTAssertEqual(settingsViewController.preferredStatusBarStyle, .lightContent)
        XCTAssertTrue(settingsViewController.tableView is UITableView)
    }

    func testViewDidLoad() {
        XCTAssertTrue(settingsViewController.viewModel is MockSettingsViewModel)
        XCTAssertTrue(mockSettingsViewModel.didCallViewDidLoad)
    }

    func testIBActions() {
        settingsViewController.saveButtonTapped(UIButton())
        XCTAssertTrue(mockSettingsViewModel.didCallSaveButtonTapped)

        settingsViewController.editButtonTapped(UIButton())
        XCTAssertTrue(mockSettingsViewModel.didCallEditButtonTapped)

        settingsViewController.dismissTapped(UIButton())
        XCTAssertTrue(mockSettingsViewModel.didCallDismissTapped)
    }

    func testUpdateButtons() {
        settingsViewController.updateButtons(enabled: true, editing: true)
        XCTAssertEqual(settingsViewController.saveButton.titleLabel?.text, mockSettingsViewModel.saveButtonTitle)
        XCTAssertEqual(settingsViewController.editButton.titleLabel?.text, mockSettingsViewModel.editButtonTitle)
        XCTAssertTrue(settingsViewController.saveButton.isEnabled)
        XCTAssertEqual(settingsViewController.saveButton.alpha, SettingsDisplayModel.buttonEnabledAlpha)

        settingsViewController.updateButtons(enabled: false, editing: true)
        XCTAssertEqual(settingsViewController.saveButton.titleLabel?.text, mockSettingsViewModel.saveButtonTitle)
        XCTAssertEqual(settingsViewController.editButton.titleLabel?.text, mockSettingsViewModel.editButtonTitle)
        XCTAssertFalse(settingsViewController.saveButton.isEnabled)
        XCTAssertEqual(settingsViewController.saveButton.alpha, SettingsDisplayModel.buttonDisabledAlpha)
    }
}
