protocol HomeViewModelDelegate: TodayViewModelDelegate, MessagePresentable {
    var feedTableView: TableViewType! { get }
    var regularsTableView: TableViewType! { get }
    var balancesTableView: TableViewType! { get }

    func showAlert(with title: String,
                   message: String,
                   confirmActionTitle: String,
                   confirmAction: @escaping () -> Void,
                   cancelActionTitle: String)
}

protocol HomeViewModelType: ViewModelType, AddTransactionViewModelDataDelegate, SettingsViewModelDataDelegate {
    func settingsButtonTapped()
    func addTransactionButtonTapped()
}
