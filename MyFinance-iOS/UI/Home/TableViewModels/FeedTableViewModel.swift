protocol FeedTableViewModelDelegate: ViewModelDelegate {

    func tableView(forModel: FeedTableViewModel) -> TableViewType?
    func didTapRefresh()
    func didSelect(transaction: Transaction)
    func didDelete(transaction: Transaction)

}

protocol FeedTableViewModelType: ViewModelType {

    func update(transactions: [Transaction])

}

class FeedTableViewModel {

    private let refreshControl = UIRefreshControl()

    private var transactions = [Date: [Transaction]]() {
        didSet {
            createSections()
            refreshControl.endRefreshing()
        }
    }

    var sections = [TableViewSection]() {
        didSet {
            updateSections(new: sections, old: oldValue)
        }
    }

    var tableViewController: TableViewController?

    weak var delegate: FeedTableViewModelDelegate?

    init() {}

}

extension FeedTableViewModel: FeedTableViewModelType {

    func viewDidLoad() {
        setupTableView()
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? FeedTableViewModelDelegate else { return }
        self.delegate = delegate
    }

    func update(transactions: [Transaction]) {
        let filteredTransactions = transactions
            .filter {
                $0.source == .externalInbound ||
                $0.source == .externalOutbound
            }
            .sorted {
                $0.created > $1.created
        }

        var transactionsTemp = [Date: [Transaction]]()

        for transaction in filteredTransactions {
            let date = transaction.created.startOfDay

            if let existingSection = transactionsTemp[date] {
                transactionsTemp[date] = existingSection + [transaction]
            } else {
                transactionsTemp[date] = [transaction]
            }
        }

        self.transactions = transactionsTemp
    }

}

extension FeedTableViewModel: TableViewModelType {

    func didSelect(indexPath: IndexPath) {
        guard let transaction = transaction(at: indexPath) else { return }
        delegate?.didSelect(transaction: transaction)
    }

    func didDelete(indexPath: IndexPath) {
        guard let transaction = transaction(at: indexPath) else { return }
        delegate?.didDelete(transaction: transaction)
    }

}

extension FeedTableViewModel {

    private func setupTableView() {
        guard let tableView = delegate?.tableView(forModel: self) else { return }
        tableView.contentInset = HomeDisplayModel.tableViewInsets
        refreshControl.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableViewController = TableViewController(tableView: tableView,
                                                  cells: [BasicTableViewCell.self],
                                                  viewModel: self)
        tableViewController?.updateCells()
    }

    private func createSections() {
        var sectionsTemp = [TableViewSection]()

        for date in transactions.keys.sorted(by: { $0 > $1 }) {
            guard let transactionsForDate = transactions[date] else { continue }

            let cellModels: [CellModelWrapper] = transactionsForDate.map({
                let displayModel = NormalTransactionDisplayModel(transaction: $0)
                return TransactionCellModel(transaction: displayModel).wrap
            })

            let title = Formatters.formatRelative(date: date)
            let section = TableViewSection(cellModels: cellModels, title: title)
            sectionsTemp.append(section)
        }

        sections = sectionsTemp
    }

    private func transaction(at indexPath: IndexPath) -> Transaction? {
        let date = transactions.keys.sorted(by: { $0 > $1 })[indexPath.section]
        return transactions[date]?[indexPath.row]
    }

    @objc private func didTapRefresh() {
        delegate?.didTapRefresh()
    }

}
