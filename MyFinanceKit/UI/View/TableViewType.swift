public protocol TableViewType: class {

    var delegate: UITableViewDelegate? { get set }
    var dataSource: UITableViewDataSource? { get set }
    var rowHeight: CGFloat { get set }
    var contentInset: UIEdgeInsets { get set }
    var refreshControl: UIRefreshControl? { get set }

    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    func reloadData()
    func beginUpdates()
    func endUpdates()
    func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
    func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
    func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)

}

extension UITableView: TableViewType {}
