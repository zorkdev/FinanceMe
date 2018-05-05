protocol BalancesTableViewModelDelegate: ViewModelDelegate {

    func tableView(forModel: BalancesTableViewModel) -> TableViewType?
    func didTapRefresh()

}

protocol BalancesTableViewModelType: ViewModelType {

    func update(endOfMonthSummaryList: EndOfMonthSummaryList)

}

class BalancesTableViewModel: ServiceClient, TableViewModelType {

    typealias ServiceProvider = DataServiceProvider

    let serviceProvider: ServiceProvider

    private enum BalancesSection {

        case currentMonth
        case chart
        case endOfMonthSummaries(Date)

        var title: String {
            switch self {
            case .currentMonth: return "This Month"
            case .chart: return "Balances"
            case .endOfMonthSummaries(let date):
                return Formatters.year.string(from: date)
            }
        }
    }

    private let refreshControl = UIRefreshControl()

    private var endOfMonthSummaryList: EndOfMonthSummaryList? {
        didSet {
            updateEndOfMonthSummaries()
            createSections()
            refreshControl.endRefreshing()
        }
    }

    private var endOfMonthSummaries = [Date: [EndOfMonthSummary]]()

    var sections = [TableViewSection]() {
        didSet {
            updateSections(new: sections, old: oldValue)
        }
    }

    var tableViewController: TableViewControllerType?

    weak var delegate: BalancesTableViewModelDelegate?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

}

extension BalancesTableViewModel: BalancesTableViewModelType {

    func viewDidLoad() {
        setupTableView()
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? BalancesTableViewModelDelegate else { return }
        self.delegate = delegate
    }

    func update(endOfMonthSummaryList: EndOfMonthSummaryList) {
        self.endOfMonthSummaryList = endOfMonthSummaryList
    }

}

extension BalancesTableViewModel {

    private func setupTableView() {
        guard let tableView = delegate?.tableView(forModel: self) else { return }
        tableView.contentInset = HomeDisplayModel.tableViewInsets
        refreshControl.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableViewController = TableViewController(tableView: tableView,
                                                  cells: [BasicTableViewCell.self,
                                                          CurrentMonthTableViewCell.self,
                                                          ChartTableViewCell.self],
                                                  viewModel: self)
    }

    private func updateEndOfMonthSummaries() {
        guard let list = endOfMonthSummaryList else { return }

        endOfMonthSummaries = [:]

        let sortedList = list.endOfMonthSummaries.sorted { $0.created > $1.created }

        for summary in sortedList {
            let date = summary.created.startOfYear

            if let existingSection = endOfMonthSummaries[date] {
                endOfMonthSummaries[date] = existingSection + [summary]
            } else {
                endOfMonthSummaries[date] = [summary]
            }
        }
    }

    private func createSections() {
        guard let list = endOfMonthSummaryList else { return }

        var sectionsTemp = [TableViewSection]()
        sectionsTemp.append(createCurrentMonthSection(list: list))
        sectionsTemp.append(createChartSection(list: list))
        sectionsTemp.append(contentsOf: createEndOfMonthSumariesSections(list: list))

        sections = sectionsTemp
    }

    func createCurrentMonthSection(list: EndOfMonthSummaryList) -> TableViewSection {
        let cellModel = CurrentMonthCellModel(currentMonthSummary: list.currentMonthSummary).wrap

        return TableViewSection(cellModels: [cellModel], title: BalancesSection.currentMonth.title)
    }

    func createChartSection(list: EndOfMonthSummaryList) -> TableViewSection {
        let payday = User.load(dataService: serviceProvider.dataService)?.payday ?? 1
        let currentSummary = EndOfMonthSummary(balance: list.currentMonthSummary.forecast,
                                               created: Date().next(day: payday, direction: .forward))
        var summaries = list.endOfMonthSummaries + [currentSummary]
        summaries.sort(by: { $0.created < $1.created })
        summaries = Array(summaries.suffix(12))
        let cellModel = ChartCellModel(endOfMonthSummaries: summaries).wrap

        return TableViewSection(cellModels: [cellModel], title: BalancesSection.chart.title)
    }

    func createEndOfMonthSumariesSections(list: EndOfMonthSummaryList) -> [TableViewSection] {
        var sectionsTemp = [TableViewSection]()

        for date in endOfMonthSummaries.keys.sorted(by: { $0 > $1 }) {
            guard let summariesForDate = endOfMonthSummaries[date] else { continue }

            let cellModels: [CellModelWrapper] = summariesForDate.map({
                let displayModel = EndOfMonthSummaryDisplayModel(date: $0.created, amount: $0.balance)
                return TransactionCellModel(transaction: displayModel).wrap
            })

            let title = BalancesSection.endOfMonthSummaries(date).title
            let section = TableViewSection(cellModels: cellModels, title: title)
            sectionsTemp.append(section)
        }

        return sectionsTemp
    }

    @objc private func didTapRefresh() {
        delegate?.didTapRefresh()
    }

}
