public protocol TableViewType: class {

    var delegate: UITableViewDelegate? { get set }
    var dataSource: UITableViewDataSource? { get set }
    var rowHeight: CGFloat { get set }

    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    func reloadData()

}

extension UITableView: TableViewType {}
