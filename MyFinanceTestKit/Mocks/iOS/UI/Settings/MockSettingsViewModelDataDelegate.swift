@testable import MyFinance_iOS

class MockSettingsViewModelDataDelegate: SettingsViewModelDataDelegate {

    var lastDidUpdateUserValue: User?

    func didUpdate(user: User) {
        lastDidUpdateUserValue = user
    }

}
