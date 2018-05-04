import NotificationCenter

class HomeViewModel: ServiceClient {

    typealias ServiceProvider = NavigatorProvider
        & NetworkServiceProvider
        & DataServiceProvider
        & WatchServiceProvider
        & SessionServiceProvider

    let serviceProvider: ServiceProvider

    private let externalTransactionsBusinessLogic: ExternalTransactionsBusinessLogic
    private let endOfMonthSummaryBusinessLogic: EndOfMonthSummaryBusinessLogic

    private var transactions = [Transaction]()
    private var endOfMonthSummaryList: EndOfMonthSummaryList?

    private let feedTableViewModel: FeedTableViewModelType
    private let regularsTableViewModel: RegularsTableViewModelType
    private let balancesTableViewModel: BalancesTableViewModelType

    let displayModel: TodayDisplayModelType = HomeDisplayModel()

    weak var delegate: HomeViewModelDelegate?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
        self.externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: serviceProvider)
        self.endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic(serviceProvider: serviceProvider)

        feedTableViewModel = FeedTableViewModel()
        regularsTableViewModel = RegularsTableViewModel()
        balancesTableViewModel = BalancesTableViewModel(serviceProvider: serviceProvider)

        feedTableViewModel.inject(delegate: self)
        regularsTableViewModel.inject(delegate: self)
        balancesTableViewModel.inject(delegate: self)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShouldReloadNotification),
            name: .UIApplicationWillEnterForeground,
            object: nil
        )
    }

}

extension HomeViewModel {

    func setupDefaults() {
        guard let balance = Balance.load(dataService: serviceProvider.dataService),
            let user = User.load(dataService: serviceProvider.dataService) else { return }
        let balanceAttributedString = createAttributedString(from: balance.effectiveBalance)
        delegate?.set(balance: balanceAttributedString)
        let allowanceAttributedString = createAttributedString(from: user.allowance)
        let allowanceIcon = SpendingBusinessLogic().allowanceIcon(for: user)
        delegate?.set(allowance: allowanceAttributedString)
        delegate?.set(allowanceIcon: allowanceIcon)

        transactions = Transaction.all(dataService: serviceProvider.dataService)
        let endOfMonthSummaries = EndOfMonthSummary.all(dataService: serviceProvider.dataService)

        guard let currentMonthSummary = CurrentMonthSummary.load(dataService: serviceProvider.dataService) else {
            return
        }

        let list = EndOfMonthSummaryList(currentMonthSummary: currentMonthSummary,
                                         endOfMonthSummaries: endOfMonthSummaries)

        feedTableViewModel.update(transactions: transactions)
        regularsTableViewModel.update(transactions: transactions)
        balancesTableViewModel.update(endOfMonthSummaryList: list)
    }

    @discardableResult func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(),
                    getUser(),
                    getExternalTransactions(),
                    getEndOfMonthSummaryList())
            .recover { error in
                self.delegate?.showError(message: error.localizedDescription)
        }
    }

    public func createAttributedString(from amount: Double) -> NSAttributedString {
        let currencyString = Formatters.currency
            .string(from: NSNumber(value: amount)) ?? HomeDisplayModel.defaultAmount
        return HomeDisplayModel.amountAttributedString(from: currencyString)
    }

    @discardableResult public func getBalance() -> Promise<Void> {
        return BalanceBusinessLogic(serviceProvider: serviceProvider)
            .getBalance().done { balance in
                let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
                self.delegate?.set(balance: balanceAttributedString)
        }
    }

    @discardableResult public func getUser() -> Promise<Void> {
        return UserBusinessLogic(serviceProvider: serviceProvider)
            .getCurrentUser().done { user in
                let allowanceAttributedString = self.createAttributedString(from: user.allowance)
                let allowanceIcon = SpendingBusinessLogic().allowanceIcon(for: user)
                self.delegate?.set(allowance: allowanceAttributedString)
                self.delegate?.set(allowanceIcon: allowanceIcon)
                self.serviceProvider.watchService.updateComplication()
        }
    }

}

// MARK: - Interface

extension HomeViewModel: HomeViewModelType {

    func viewDidLoad() {
        feedTableViewModel.viewDidLoad()
        regularsTableViewModel.viewDidLoad()
        balancesTableViewModel.viewDidLoad()
        setupDefaults()
        updateData()
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? HomeViewModelDelegate else { return }
        self.delegate = delegate
    }

    func settingsButtonTapped() {
        let settingsViewModel = SettingsViewModel(serviceProvider: serviceProvider,
                                                  dataDelegate: self)
        serviceProvider.navigator.moveTo(scene: .settings, viewModel: settingsViewModel)
    }

    func addTransactionButtonTapped() {
        let addTransactionViewModel = AddTransactionViewModel(serviceProvider: serviceProvider,
                                                              dataDelegate: self)
        serviceProvider.navigator.moveTo(scene: .addTransaction, viewModel: addTransactionViewModel)
    }

}

extension HomeViewModel: FeedTableViewModelDelegate {}
extension HomeViewModel: RegularsTableViewModelDelegate {}
extension HomeViewModel: BalancesTableViewModelDelegate {

    func didTapRefresh() {
        updateData()
    }

    func didSelect(transaction: Transaction) {
        let addTransactionViewModel = AddTransactionViewModel(serviceProvider: serviceProvider,
                                                              dataDelegate: self,
                                                              state: .edit,
                                                              transaction: transaction)
        serviceProvider.navigator.moveTo(scene: .addTransaction, viewModel: addTransactionViewModel)
    }

    func didDelete(transaction: Transaction) {
        delegate?.showAlert(with: HomeDisplayModel.DeleteAlert.title,
                            message: HomeDisplayModel.DeleteAlert.message,
                            confirmActionTitle: HomeDisplayModel.DeleteAlert.confirmButtonTitle,
                            confirmAction: { self.delete(transaction: transaction) },
                            cancelActionTitle: HomeDisplayModel.DeleteAlert.cancelButtonTitle)
    }

    func tableView(forModel: FeedTableViewModel) -> TableViewType? {
        return delegate?.feedTableView
    }

    func tableView(forModel: RegularsTableViewModel) -> TableViewType? {
        return delegate?.regularsTableView
    }

    func tableView(forModel: BalancesTableViewModel) -> TableViewType? {
        return delegate?.balancesTableView
    }

}

// MARK: - Private methods

extension HomeViewModel {

    @objc private func handleShouldReloadNotification() {
        updateData()
    }

    private func updateTableViewModels() {
        feedTableViewModel.update(transactions: transactions)
        regularsTableViewModel.update(transactions: transactions)

        if let endOfMonthSummaryList = endOfMonthSummaryList {
            balancesTableViewModel.update(endOfMonthSummaryList: endOfMonthSummaryList)
        }
    }

    private func getExternalTransactions() -> Promise<Void> {
        return externalTransactionsBusinessLogic.getExternalTransactions()
            .done { transactions in
                self.transactions = transactions
                self.transactions.save(dataService: self.serviceProvider.dataService)
                self.feedTableViewModel.update(transactions: transactions)
                self.regularsTableViewModel.update(transactions: transactions)
        }
    }

    private func delete(transaction: Transaction) {
        externalTransactionsBusinessLogic.delete(transaction: transaction).done {
            self.getUser()
            self.getEndOfMonthSummaryList()
            self.transactions = self.transactions.filter { $0.id != transaction.id }
            self.updateTableViewModels()

        }.catch { error in
            self.delegate?.showError(message: error.localizedDescription)
        }
    }

    @discardableResult private func getEndOfMonthSummaryList() -> Promise<Void> {
        return endOfMonthSummaryBusinessLogic.getEndOfMonthSummaryList()
            .done { endOfMonthSummaryList in
                endOfMonthSummaryList.endOfMonthSummaries.save(dataService: self.serviceProvider.dataService)
                endOfMonthSummaryList.currentMonthSummary.save(dataService: self.serviceProvider.dataService)
                self.balancesTableViewModel.update(endOfMonthSummaryList: endOfMonthSummaryList)
            }
    }

}

extension HomeViewModel: AddTransactionViewModelDataDelegate {

    func didCreate(transaction: Transaction) {
        getUser()
        getEndOfMonthSummaryList()
        transactions.append(transaction)
        updateTableViewModels()
    }

    func didUpdate(transaction: Transaction) {
        getUser()
        getEndOfMonthSummaryList()

        guard let index = transactions.index(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
        updateTableViewModels()
    }

}

extension HomeViewModel: SettingsViewModelDataDelegate {

    func didUpdate(user: User) {
        let allowanceAttributedString = self.createAttributedString(from: user.allowance)
        self.delegate?.set(allowance: allowanceAttributedString)
        updateTableViewModels()
        serviceProvider.watchService.updateComplication()
    }

}
