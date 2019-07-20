@testable import MyFinance_iOS

class MockSettingsViewModelDataDelegate: SettingsViewModelDataDelegate {
    var lastDidUpdateUserValue: User?
    var didCallDidReconcile = false

    func didUpdate(user: User) {
        lastDidUpdateUserValue = user
    }

    func didReconcile() {
        didCallDidReconcile = true
    }
}
