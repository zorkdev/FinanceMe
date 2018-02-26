@testable import MyFinance_iOS

class MockSettingsViewModelDelegate: SettingsViewModelDelegate {

    var didCallSetupDefault = false
    var didCallUpdate = false
    var didCallDismiss = false

    func setupDefault(displayModel: SettingsDisplayModel) {
        didCallSetupDefault = true
    }

    func update(editing: Bool) {
        didCallUpdate = true
    }

    func dismiss(_ sender: AnyObject) {
        didCallDismiss = true
    }

}
