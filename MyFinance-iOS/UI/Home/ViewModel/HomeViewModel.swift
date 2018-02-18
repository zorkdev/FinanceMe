import NotificationCenter

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

class HomeViewModel {

    enum Tab: Int {
        case transactions = 0, bills, balances
    }

    enum RegularsSection: Int {
        case allowance, inbound, outbound
    }

    private let externalTransactionsBusinessLogic: ExternalTransactionsBusinessLogic
    private let endOfMonthSummaryBusinessLogic: EndOfMonthSummaryBusinessLogic

    private var currentMonthSummary: CurrentMonthSummary? {
        didSet {
            currentMonthSummary?.save(dataService: serviceProvider.dataService)
        }
    }

    private var endOfMonthSummaries = [EndOfMonthSummary]() {
        didSet {
            endOfMonthSummaries.save(dataService: serviceProvider.dataService)
        }
    }

    private var externalTransactions = [Transaction]() {
        didSet {
            externalTransactions.save(dataService: serviceProvider.dataService)
        }
    }

    private var normalTransactions = [Transaction]()
    private var regularTransactions = [Transaction]()

    private var normalCellModels = [Date: [HomeCellModel]]()
    private var regularCellModels = [RegularsSection: [HomeCellModel]]()
    private var balanceCellModels = [Date: [HomeCellModel]]()
    private var currentMonthCellModels = [HomeCurrentMonthCellModel]()
    private var chartCellModels = [HomeChartCellModel]()

    let serviceProvider: NetworkDataWatchServiceProvider

    let displayModel: TodayDisplayModelType = HomeDisplayModel()

    weak var delegate: HomeViewModelDelegate?

    init(serviceProvider: NetworkDataWatchServiceProvider,
         delegate: HomeViewModelDelegate) {
        self.serviceProvider = serviceProvider
        self.delegate = delegate
        self.externalTransactionsBusinessLogic =
            ExternalTransactionsBusinessLogic(networkService: serviceProvider.networkService)
        self.endOfMonthSummaryBusinessLogic =
            EndOfMonthSummaryBusinessLogic(networkService: serviceProvider.networkService)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShouldReloadNotification),
            name: .UIApplicationWillEnterForeground,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension HomeViewModel {

    func setupDefaults() {
        guard let balance = Balance.load(dataService: serviceProvider.dataService),
            let user = User.load(dataService: serviceProvider.dataService) else { return }
        let balanceAttributedString = createAttributedString(from: balance.effectiveBalance)
        delegate?.set(balance: balanceAttributedString)
        let allowanceAttributedString = createAttributedString(from: user.allowance)
        delegate?.set(allowance: allowanceAttributedString)

        externalTransactions = Transaction.all(dataService: serviceProvider.dataService)
        updateTransactions()
        endOfMonthSummaries = EndOfMonthSummary.all(dataService: serviceProvider.dataService)
        currentMonthSummary = CurrentMonthSummary.load(dataService: serviceProvider.dataService)
        updateBalances()
        delegate?.reloadTableView()
    }

    @discardableResult func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(),
                    getUser(),
                    getExternalTransactions(),
                    getEndOfMonthSummaryList())
            .ensure {
                self.delegate?.endRefreshing()
            }.recover { error in
                self.delegate?.showError(message: error.localizedDescription)
        }
    }

    public func createAttributedString(from amount: Double) -> NSAttributedString {
        let currencyString = Formatters.currency
            .string(from: NSNumber(value: amount)) ?? displayModel.defaultAmount
        return displayModel.amountAttributedString(from: currencyString)
    }

    @discardableResult public func getBalance() -> Promise<Void> {
        return BalanceBusinessLogic(networkService: serviceProvider.networkService,
                                    dataService: serviceProvider.dataService)
            .getBalance().done { balance in
                let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
                self.delegate?.set(balance: balanceAttributedString)
        }
    }

    @discardableResult public func getUser() -> Promise<Void> {
        return UserBusinessLogic(networkService: serviceProvider.networkService,
                                 dataService: serviceProvider.dataService)
            .getCurrentUser().done { user in
                let allowanceAttributedString = self.createAttributedString(from: user.allowance)
                let spendingBusinessLogic =
                    SpendingBusinessLogic(dataService: self.serviceProvider.dataService)
                let allowanceIcon = spendingBusinessLogic.allowanceIcon(for: user)
                self.delegate?.set(allowance: allowanceAttributedString)
                self.delegate?.set(allowanceIcon: allowanceIcon)
                self.serviceProvider.watchService.updateComplication()
        }
    }

}

// MARK: - Interface

extension HomeViewModel: HomeViewModelType {

    func viewDidLoad() {
        setupDefaults()
        updateData()
    }

    func numberOfSections(in tab: Tab) -> Int {
        switch tab {
        case .transactions:
            return normalCellModels.count
        case .bills:
            return regularCellModels.count
        case .balances:
            let currentMonthCount = currentMonthCellModels.isEmpty ? 0 : 1
            let chartCount = chartCellModels.isEmpty ? 0 : 1
            return balanceCellModels.count + currentMonthCount + chartCount
        }
    }

    func numberOfRows(in tab: Tab, in section: Int) -> Int {
        switch tab {
        case .transactions:
            let key = normalCellModels.keys.sorted(by: { $0 > $1 })[section]
            return normalCellModels[key]?.count ?? 0
        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return 0 }
            return regularCellModels[section]?.count ?? 0
        case .balances:
            let modifier = (currentMonthCellModels.isEmpty) ? 0 : -1
                + (chartCellModels.isEmpty ? 0 : -1)

            if section == 0, currentMonthCellModels.isEmpty == false {
                return currentMonthCellModels.count
            }

            if section == 1, chartCellModels.isEmpty == false {
                return chartCellModels.count
            }

            let key = balanceCellModels.keys.sorted(by: { $0 > $1 })[section + modifier]
            return balanceCellModels[key]?.count ?? 0
        }
    }

    func cellModel(for tab: Tab, section: Int, row: Int) -> HomeCellModelType? {
        switch tab {
        case .transactions:
            let key = normalCellModels.keys.sorted(by: { $0 > $1 })[section]
            return normalCellModels[key]?[row]
        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return nil }
            return regularCellModels[section]?[row]
        case .balances:
            let modifier = (currentMonthCellModels.isEmpty) ? 0 : -1
                + (chartCellModels.isEmpty ? 0 : -1)

            if section == 0, currentMonthCellModels.isEmpty == false {
                return currentMonthCellModels[row]
            }

            if section == 1, chartCellModels.isEmpty == false {
                return chartCellModels[row]
            }

            let key = balanceCellModels.keys.sorted(by: { $0 > $1 })[section + modifier]
            return balanceCellModels[key]?[row]
        }
    }

    func header(for tab: Tab, section: Int) -> String? {
        switch tab {
        case .transactions:
            let date = normalCellModels.keys.sorted(by: { $0 > $1 })[section]
            return Formatters.formatRelative(date: date)
        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return nil }
            switch section {
            case .allowance: return HomeDisplayModel.regularAllowanceSectionTitle
            case .inbound: return HomeDisplayModel.regularInboundSectionTitle
            case .outbound: return HomeDisplayModel.regularOutboundSectionTitle
            }
        case .balances:
            let modifier = (currentMonthCellModels.isEmpty) ? 0 : -1
                + (chartCellModels.isEmpty ? 0 : -1)

            if section == 0, currentMonthCellModels.isEmpty == false {
                return HomeDisplayModel.currentMonthTitle
            }

            if section == 1, chartCellModels.isEmpty == false {
                return HomeDisplayModel.chartTitle
            }

            let date = balanceCellModels.keys.sorted(by: { $0 > $1 })[section + modifier]
            return Formatters.year.string(from: date)
        }
    }

    func canEdit(tab: HomeViewModel.Tab, section: Int, row: Int) -> Bool {
        switch tab {
        case .transactions:
            return true
        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return false }
            switch section {
            case .allowance: return false
            case .inbound, .outbound: return true
            }
        case .balances:
            return false
        }
    }

    func delete(from tab: Tab, section: Int, row: Int) {
        let transaction: Transaction
        let shouldDeleteSection: Bool

        switch tab {
        case .transactions:
            let key = normalCellModels.keys.sorted(by: { $0 > $1 })[section]
            transaction = normalTransactions
                .filter({ $0.created.isInSameDay(as: key) })[row]
            shouldDeleteSection = normalCellModels[key]?.count == 1

        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return }
            switch section {
            case .allowance: return
            case .inbound:
                transaction = regularTransactions
                    .filter({ $0.source == .externalRegularInbound })[row]
            case .outbound:
                transaction = regularTransactions
                    .filter({ $0.source == .externalRegularOutbound })[row]
            }
            shouldDeleteSection = regularCellModels[section]?.count == 1

        case .balances:
            return
        }

        let row = shouldDeleteSection ? nil : row

        delegate?.showAlert(with: HomeDisplayModel.DeleteAlert.title,
                            message: HomeDisplayModel.DeleteAlert.message,
                            confirmActionTitle: HomeDisplayModel.DeleteAlert.confirmButtonTitle,
                            confirmAction: { self.delete(transaction: transaction,
                                                         section: section,
                                                         row: row) },
                            cancelActionTitle: HomeDisplayModel.DeleteAlert.cancelButtonTitle)
    }

    func height(for tab: HomeViewModel.Tab, section: Int, row: Int) -> CGFloat {
        switch tab {
        case .transactions, .bills:
            return HomeCellModel.rowHeight
        case .balances:
            if section == 0, currentMonthCellModels.isEmpty == false {
                return HomeCurrentMonthCellModel.rowHeight
            }

            if section == 1, chartCellModels.isEmpty == false {
                return HomeChartCellModel.rowHeight
            }

            return HomeCellModel.rowHeight
        }
    }

    func refreshTapped() {
        updateData()
    }

}

// MARK: - Private methods

extension HomeViewModel {

    @objc private func handleShouldReloadNotification() {
        updateData()
    }

    private func updateBalances() {
        endOfMonthSummaries = endOfMonthSummaries
            .sorted(by: { $0.created > $1.created })

        configureBalanceCellModels()
    }

    private func updateTransactions() {
        normalTransactions = externalTransactions
            .filter {
                $0.source == .externalInbound ||
                $0.source == .externalOutbound
            }
            .sorted(by: { $0.created > $1.created })

        regularTransactions = externalTransactions
            .filter {
                $0.source == .externalRegularInbound ||
                $0.source == .externalRegularOutbound
            }
            .sorted(by: {
                switch ($0.amount, $1.amount) {
                case _ where $0.amount < 0 && $1.amount < 0:
                    return $0.amount < $1.amount
                case _ where $0.amount > 0 && $1.amount > 0:
                    return $0.amount > $1.amount
                case _ where $0.amount < 0 && $1.amount > 0:
                    return false
                case _ where $0.amount > 0 && $1.amount < 0:
                    return true
                default: return false
                }
            })

        configureCellModels()
    }

    private func configureBalanceCellModels() {
        currentMonthCellModels = []
        chartCellModels = []
        balanceCellModels = [:]

        if let currentMonthSummary = currentMonthSummary {
            let allowance = Formatters.currencyPlusMinusSign
                .string(from: NSNumber(value: currentMonthSummary.allowance))
                ?? displayModel.defaultAmount

            let forecast = Formatters.currencyPlusMinusSign
                .string(from: NSNumber(value: currentMonthSummary.forecast))
                ?? displayModel.defaultAmount

            let homeCurrentMonthCellModel = HomeCurrentMonthCellModel(allowance: allowance,
                                                               forecast: forecast)

            currentMonthCellModels = [homeCurrentMonthCellModel]

            let payday = User.load(dataService: serviceProvider.dataService)?.payday ?? 0
            let currentSummary = EndOfMonthSummary(balance: currentMonthSummary.forecast,
                                                   created: Date().next(day: payday, direction: .forward))
            var summaries = endOfMonthSummaries + [currentSummary]
            summaries.sort(by: { $0.created < $1.created })
            summaries = Array(summaries.suffix(12))
            let homeChartCellModel = HomeChartCellModel(endOfMonthSummaries: summaries)
            chartCellModels = [homeChartCellModel]
        }

        for endOfMonthSummary in endOfMonthSummaries {
            var title = Formatters.month.string(from: endOfMonthSummary.created)

            if endOfMonthSummary.created > Date() {
                title = HomeDisplayModel.currentMonthTitle
            }

            let detail = Formatters.currencyPlusMinusSign
                .string(from: NSNumber(value: endOfMonthSummary.balance))
                ?? displayModel.defaultAmount
            let detailColor = endOfMonthSummary.balance > 0 ?
                HomeCellDisplayModel.positiveColor : HomeCellDisplayModel.negativeBalanceColor
            let cellModel = HomeCellModel(title: title,
                                          detail: detail,
                                          detailColor: detailColor)
            let date = endOfMonthSummary.created.startOfYear

            if let existingSection = balanceCellModels[date] {
                balanceCellModels[date] = existingSection + [cellModel]
            } else {
                balanceCellModels[date] = [cellModel]
            }
        }
    }

    private func configureCellModels() {
        configureNormalCellModels()
        configureRegularCellModels()
    }

    private func configureNormalCellModels() {
        normalCellModels = [:]

        for transaction in normalTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let detailColor = transaction.amount > 0 ?
                HomeCellDisplayModel.positiveColor : HomeCellDisplayModel.negativeColor
            let cellModel = HomeCellModel(title: title,
                                          detail: detail,
                                          detailColor: detailColor)
            let date = transaction.created.startOfDay

            if let existingSection = normalCellModels[date] {
                normalCellModels[date] = existingSection + [cellModel]
            } else {
                normalCellModels[date] = [cellModel]
            }
        }
    }

    private func configureRegularCellModels() {
        regularCellModels = [:]

        for transaction in regularTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let detailColor = transaction.amount > 0 ?
                HomeCellDisplayModel.positiveColor : HomeCellDisplayModel.negativeColor
            let cellModel = HomeCellModel(title: title,
                                          detail: detail,
                                          detailColor: detailColor)

            switch transaction.source {
            case .externalRegularInbound:
                if let existingSection = regularCellModels[.inbound] {
                    regularCellModels[.inbound] = existingSection + [cellModel]
                } else {
                    regularCellModels[.inbound] = [cellModel]
                }
            case .externalRegularOutbound:
                if let existingSection = regularCellModels[.outbound] {
                    regularCellModels[.outbound] = existingSection + [cellModel]
                } else {
                    regularCellModels[.outbound] = [cellModel]
                }
            default: continue
            }
        }

        let monthlyAllowance = regularTransactions
            .flatMap({ $0.amount })
            .reduce(0, +)
        let detail = Formatters.currency
            .string(from: NSNumber(value: monthlyAllowance))
            ?? displayModel.defaultAmount
        let detailColor = monthlyAllowance > 0 ?
            HomeCellDisplayModel.negativeColor : HomeCellDisplayModel.negativeBalanceColor
        let cellModel = HomeCellModel(title: HomeDisplayModel.monthlyAllowanceTitle,
                                      detail: detail,
                                      detailColor: detailColor)
        regularCellModels[.allowance] = [cellModel]
    }

}

// MARK: - Business methods

extension HomeViewModel {

    private func getExternalTransactions() -> Promise<Void> {
        return externalTransactionsBusinessLogic.getExternalTransactions()
            .done { transactions in
                self.externalTransactions = transactions
                self.updateTransactions()
                self.delegate?.reloadTableView()
        }
    }

    private func delete(transaction: Transaction, section: Int, row: Int?) {
        externalTransactionsBusinessLogic.delete(transaction: transaction).done {
            self.getUser()
            self.externalTransactions = self.externalTransactions.filter { $0.id != transaction.id }
            self.updateTransactions()
            switch transaction.source {
            case .externalInbound, .externalOutbound:
                if let row = row {
                    self.delegate?.delete(from: .transactions,
                                                                      section: section,
                                                                      row: row)
                } else {
                    self.delegate?.delete(from: .transactions,
                                                                      section: section)
                }
            case .externalRegularInbound, .externalRegularOutbound:
                if let row = row {
                    self.delegate?.delete(from: .bills,
                                                                      section: section,
                                                                      row: row)
                } else {
                    self.delegate?.delete(from: .bills,
                                                                      section: section)
                }
            default: break
            }
        }.catch { error in
            self.delegate?.showError(message: error.localizedDescription)
        }
    }

    private func getEndOfMonthSummaryList() -> Promise<Void> {
        return endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList()
            .done { endOfMonthSummaryList in
                self.endOfMonthSummaries = endOfMonthSummaryList.endOfMonthSummaries
                self.currentMonthSummary = endOfMonthSummaryList.currentMonthSummary
                self.updateBalances()
                self.delegate?.reloadTableView()
            }
    }

}

extension HomeViewModel: AddTransactionViewModelDataDelegate {

    func didCreate(transaction: Transaction) {
        getUser()
        externalTransactions.append(transaction)
        updateTransactions()
        delegate?.reloadTableView()
    }

}

extension HomeViewModel: SettingsViewModelDataDelegate {

    func didUpdate(user: User) {
        let allowanceAttributedString = self.createAttributedString(from: user.allowance)
        self.delegate?.set(allowance: allowanceAttributedString)
        updateTransactions()
        delegate?.reloadTableView()
        serviceProvider.watchService.updateComplication()
    }

}
