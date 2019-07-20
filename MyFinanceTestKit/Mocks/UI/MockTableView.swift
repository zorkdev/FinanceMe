@testable import MyFinanceKit

class MockTableView: TableViewType {
    //swiftlint:disable weak_delegate
    var delegate: UITableViewDelegate?
    var dataSource: UITableViewDataSource?

    var rowHeight: CGFloat = 10
    var contentInset: UIEdgeInsets = .zero
    var refreshControl: UIRefreshControl?

    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {}
    func reloadData() {}
    func beginUpdates() {}
    func endUpdates() {}
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {}
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {}
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {}
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {}
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {}
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {}
}
