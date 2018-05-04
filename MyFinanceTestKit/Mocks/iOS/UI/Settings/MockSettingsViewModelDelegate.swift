@testable import MyFinance_iOS

class MockSettingsViewModelDelegate: SettingsViewModelDelegate {

    var lastUpdateButtonsValue: (enabled: Bool, editing: Bool)?

    var tableView: TableViewType = UITableView()

    func updateButtons(enabled: Bool, editing: Bool) {
        lastUpdateButtonsValue = (enabled: enabled, editing: editing)
    }

}
