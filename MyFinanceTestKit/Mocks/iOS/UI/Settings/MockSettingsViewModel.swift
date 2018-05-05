@testable import MyFinance_iOS

class MockSettingsViewModel: SettingsViewModelType {

    var didCallViewDidLoad = false
    var didCallEditButtonTapped = false
    var didCallSaveButtonTapped = false
    var didCallDismissTapped = false
    var lastInjectValue: ViewModelDelegate?

    var saveButtonTitle: String {
        return "saveButtonTitle"
    }

    var editButtonTitle: String {
        return "editButtonTitle"
    }

    func viewDidLoad() {
        didCallViewDidLoad = true
    }

    func editButtonTapped() {
        didCallEditButtonTapped = true
    }

    func saveButtonTapped() {
        didCallSaveButtonTapped = true
    }

    func dismissTapped() {
        didCallDismissTapped = true
    }

    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }

}
