protocol HomeViewModelDelegate: TodayViewModelDelegate, MessagePresentable {

    func reloadTableView()
    func endRefreshing()
    func delete(from tab: HomeViewModel.Tab, section: Int)
    func delete(from tab: HomeViewModel.Tab, section: Int, row: Int)
    func showAlert(with title: String,
                   message: String,
                   confirmActionTitle: String,
                   confirmAction: @escaping () -> Void,
                   cancelActionTitle: String)

}

protocol HomeViewModelType: ViewModelType, AddTransactionViewModelDataDelegate, SettingsViewModelDataDelegate {

    func numberOfSections(in tab: HomeViewModel.Tab) -> Int
    func numberOfRows(in tab: HomeViewModel.Tab, in section: Int) -> Int
    func cellModel(for tab: HomeViewModel.Tab, section: Int, row: Int) -> HomeCellModelType?
    func header(for tab: HomeViewModel.Tab, section: Int) -> String?
    func canEdit(tab: HomeViewModel.Tab, section: Int, row: Int) -> Bool
    func delete(from tab: HomeViewModel.Tab, section: Int, row: Int)
    func height(for tab: HomeViewModel.Tab, section: Int, row: Int) -> CGFloat
    func refreshTapped()

}
