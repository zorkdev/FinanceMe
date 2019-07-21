public protocol TableViewType: AnyObject {
    var delegate: UITableViewDelegate? { get set }
    var dataSource: UITableViewDataSource? { get set }
    // swiftlint:disable:next unused_declaration
    var rowHeight: CGFloat { get set }
    var contentInset: UIEdgeInsets { get set }

    #if os(iOS)
    var refreshControl: UIRefreshControl? { get set }
    #endif

    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    func reloadData()
    func beginUpdates()
    func endUpdates()
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

extension UITableView: TableViewType {}
