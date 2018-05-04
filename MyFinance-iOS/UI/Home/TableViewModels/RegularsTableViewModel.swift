protocol RegularsTableViewModelDelegate: ViewModelDelegate {

    func tableView(forModel: RegularsTableViewModel) -> TableViewType?
    func didTapRefresh()
    func didSelect(transaction: Transaction)
    func didDelete(transaction: Transaction)

}

protocol RegularsTableViewModelType: ViewModelType {

    func update(transactions: [Transaction])

}

class RegularsTableViewModel {

    private enum RegularsSection: Int {
        case monthlyAllowance, inbound, outbound

        var title: String {
            switch self {
            case .monthlyAllowance: return ""
            case .inbound: return "Incoming"
            case .outbound: return "Outgoing"
            }
        }
    }

    private let refreshControl = UIRefreshControl()

    private var transactions = [RegularsSection: [Transaction]]() {
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

    weak var delegate: RegularsTableViewModelDelegate?

    init() {}

}

extension RegularsTableViewModel: RegularsTableViewModelType {

    func viewDidLoad() {
        setupTableView()
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? RegularsTableViewModelDelegate else { return }
        self.delegate = delegate
    }

    func update(transactions: [Transaction]) {
        let filteredTransactions = transactions
            .filter {
                $0.source == .externalRegularInbound ||
                $0.source == .externalRegularOutbound
            }
            .sorted(by: sortTransactions)

        var transactionsTemp = [RegularsSection: [Transaction]]()

        for transaction in filteredTransactions {
            switch transaction.source {
            case .externalRegularInbound:
                if let existingSection = transactionsTemp[.inbound] {
                    transactionsTemp[.inbound] = existingSection + [transaction]
                } else {
                    transactionsTemp[.inbound] = [transaction]
                }
            case .externalRegularOutbound:
                if let existingSection = transactionsTemp[.outbound] {
                    transactionsTemp[.outbound] = existingSection + [transaction]
                } else {
                    transactionsTemp[.outbound] = [transaction]
                }
            default: continue
            }
        }

        self.transactions = transactionsTemp
    }

}

extension RegularsTableViewModel: TableViewModelType {

    func didSelect(indexPath: IndexPath) {
        guard let transaction = transaction(at: indexPath) else { return }
        delegate?.didSelect(transaction: transaction)
    }

    func didDelete(indexPath: IndexPath) {
        guard let transaction = transaction(at: indexPath) else { return }
        delegate?.didDelete(transaction: transaction)
    }

}

extension RegularsTableViewModel {

    private func setupTableView() {
        guard let tableView = delegate?.tableView(forModel: self) else { return }
        tableView.contentInset = HomeDisplayModel.tableViewInsets
        refreshControl.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableViewController = TableViewController(tableView: tableView,
                                                  cells: [BasicTableViewCell.self],
                                                  viewModel: self)
    }

    private func createSections() {
        var sectionsTemp = [TableViewSection]()

        sectionsTemp.append(createMonthlyAllowanceSection())

        let inboundCellModels: [CellModelWrapper] = transactions[.inbound]?.map({
            let displayModel = NormalTransactionDisplayModel(transaction: $0)
            return TransactionCellModel(transaction: displayModel).wrap
        }) ?? []
        let inboundSection = TableViewSection(cellModels: inboundCellModels,
                                              title: RegularsSection.inbound.title)
        sectionsTemp.append(inboundSection)

        let outboundCellModels: [CellModelWrapper] = transactions[.outbound]?.map({
            let displayModel = NormalTransactionDisplayModel(transaction: $0)
            return TransactionCellModel(transaction: displayModel).wrap
        }) ?? []
        let outboundSection = TableViewSection(cellModels: outboundCellModels,
                                               title: RegularsSection.outbound.title)
        sectionsTemp.append(outboundSection)

        sections = sectionsTemp
    }

    private func createMonthlyAllowanceSection() -> TableViewSection {
        let monthlyAllowance = transactions
            .flatMap({ $0.value })
            .compactMap({ $0.amount })
            .reduce(0, +)

        let cellModel = TransactionCellModel(transaction: MonthlyAllowanceDisplayModel(amount: monthlyAllowance)).wrap

        return TableViewSection(cellModels: [cellModel], title: RegularsSection.monthlyAllowance.title)
    }

    private func transaction(at indexPath: IndexPath) -> Transaction? {
        guard let section = RegularsSection(rawValue: indexPath.section),
            section != .monthlyAllowance else { return nil }

        return transactions[section]?[indexPath.row]
    }

    private func sortTransactions(lhs: Transaction, rhs: Transaction) -> Bool {
        switch (lhs.amount, rhs.amount) {
        case _ where lhs.amount < 0 && rhs.amount < 0:
            return lhs.amount < rhs.amount
        case _ where lhs.amount > 0 && rhs.amount > 0:
            return lhs.amount > rhs.amount
        case _ where lhs.amount < 0 && rhs.amount > 0:
            return false
        case _ where lhs.amount > 0 && rhs.amount < 0:
            return true
        default: return false
        }
    }

    @objc private func didTapRefresh() {
        delegate?.didTapRefresh()
    }

}
