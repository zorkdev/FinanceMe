@testable import MyFinance_iOS

class MockSettingsViewModel: SettingsViewModelType {

    var didCallViewDidLoad = false
    var didCallEditButtonTapped = false
    var didCallSaveButtonTapped = false
    var didCallDismissTapped = false
    var lastInjectValue: ViewModelDelegate?

    var shouldEnableSaveButtonReturnValue = false
    var formattedReturnValue = ""
    var numberOfComponentsReturnValue = 0
    var pickerViewNumberOfRowsInReturnValue = 0
    var pickerViewTitleReturnValue: String?
    var pickerViewRowInComponentReturnValue = (row: 0, component: 0)

    var saveButtonTitle: String {
        return ""
    }

    func viewDidLoad() {
        didCallViewDidLoad = true
    }

    func shouldEnableSaveButton(displayModel: SettingsDisplayModel) -> Bool {
        return shouldEnableSaveButtonReturnValue
    }

    func editButtonTapped() {
        didCallEditButtonTapped = true
    }

    func saveButtonTapped(with displayModel: SettingsDisplayModel?) {
        didCallSaveButtonTapped = true
    }

    func dismissTapped() {
        didCallDismissTapped = true
    }

    func formatted(amount: String, original: String) -> String {
        return formattedReturnValue
    }

    func numberOfComponentsInPickerView() -> Int {
        return numberOfComponentsReturnValue
    }

    func pickerViewNumberOfRowsIn(component: Int) -> Int {
        return pickerViewNumberOfRowsInReturnValue
    }

    func pickerViewTitle(for row: Int, for component: Int) -> String? {
        return pickerViewTitleReturnValue
    }

    func pickerViewRowInComponent(for payday: String) -> (row: Int, component: Int) {
        return pickerViewRowInComponentReturnValue
    }

    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }

}
