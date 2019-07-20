@testable import MyFinance_iOS

class SettingsViewModelTests: ServiceClientiOSTestCase {
    //swiftlint:disable weak_delegate
    var mockSettingsViewModelDelegate: MockSettingsViewModelDelegate!
    var mockSettingsViewModelDataDelegate: MockSettingsViewModelDataDelegate!
    var mockTableViewController: MockTableViewController!
    var user = Factory.makeUser()
    var settingsViewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()

        mockSettingsViewModelDelegate = MockSettingsViewModelDelegate()
        mockSettingsViewModelDataDelegate = MockSettingsViewModelDataDelegate()
        mockTableViewController = MockTableViewController()
        settingsViewModel = SettingsViewModel(serviceProvider: mockAppState,
                                              dataDelegate: mockSettingsViewModelDataDelegate)
        settingsViewModel.inject(delegate: mockSettingsViewModelDelegate)
        mockAppState.mockDataService.loadReturnValues = [user, user, user, user]
    }

    func testInit() {
        XCTAssertEqual(settingsViewModel.saveButtonTitle, SettingsDisplayModel.logOutButtonTitle)
        XCTAssertEqual(settingsViewModel.editButtonTitle, SettingsDisplayModel.editButtonTitle)
        XCTAssertFalse(settingsViewModel.isEnabled(inputCell: MockInputCellModel()))
        XCTAssertEqual(settingsViewModel.returnKeyType(inputCell: MockInputCellModel()),
                       .done)
        XCTAssertEqual(settingsViewModel.defaultValue(amountCell: MockAmountInputCellModel()),
                       user.largeTransaction)
        XCTAssertEqual(settingsViewModel.defaultValue(dateCell: MockDateInputCellModel()),
                       user.startDate)
        XCTAssertEqual(settingsViewModel.defaultValue(textCell: MockTextInputCellModel()),
                       user.name)
        XCTAssertEqual(settingsViewModel.defaultValue(paydayCell: MockPaydayInputCellModel()),
                       Payday(intValue: user.payday))
        XCTAssertEqual(settingsViewModel.sections.count, 1)
        XCTAssertEqual(settingsViewModel.sections.first?.cellModels.count, 4)
        XCTAssertTrue(settingsViewModel.sections.first?.cellModels
            .contains { $0.wrapped is AmountInputCellModel } == true)
        XCTAssertTrue(settingsViewModel.sections.first?.cellModels
            .contains { $0.wrapped is DateInputCellModel } == true)
        XCTAssertTrue(settingsViewModel.sections.first?.cellModels
            .contains { $0.wrapped is TextInputCellModel } == true)
        XCTAssertTrue(settingsViewModel.sections.first?.cellModels
            .contains { $0.wrapped is PaydayInputCellModel } == true)
        XCTAssertNil(settingsViewModel.tableViewController)
    }

    func testViewDidLoad() {
        settingsViewModel.viewDidLoad()
        XCTAssertTrue(settingsViewModel.tableViewController is TableViewController)
    }

    func testDidFinishLoadingTableView() {
        settingsViewModel.didFinishLoadingTableView()

        XCTAssertTrue(mockSettingsViewModelDelegate.lastUpdateButtonsValue?.enabled == true)
        XCTAssertTrue(mockSettingsViewModelDelegate.lastUpdateButtonsValue?.editing == false)
    }

    func testEditButtonTapped() {
        settingsViewModel.tableViewController = mockTableViewController
        settingsViewModel.editButtonTapped()

        XCTAssertTrue(mockTableViewController.didCallUpdateCells)
        XCTAssertTrue(mockSettingsViewModelDelegate.lastUpdateButtonsValue?.enabled == false)
        XCTAssertTrue(mockSettingsViewModelDelegate.lastUpdateButtonsValue?.editing == true)
    }

    func testDidChangeValue() {
        settingsViewModel.didChangeValue()

        XCTAssertTrue(mockSettingsViewModelDelegate.lastUpdateButtonsValue?.enabled == true)
        XCTAssertTrue(mockSettingsViewModelDelegate.lastUpdateButtonsValue?.editing == false)
    }

    func testDidSetSections() {
        settingsViewModel.tableViewController = mockTableViewController
        settingsViewModel.sections = []

        XCTAssertNotNil(mockTableViewController.lastUpdateCellsValue)
    }
}
