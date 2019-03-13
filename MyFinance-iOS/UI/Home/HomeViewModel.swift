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

    private let todayViewModel: TodayPresentable

    private let feedTableViewModel: FeedTableViewModelType
    private let regularsTableViewModel: RegularsTableViewModelType
    private let balancesTableViewModel: BalancesTableViewModelType

    weak var delegate: HomeViewModelDelegate?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider

        externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: serviceProvider)
        endOfMonthSummaryBusinessLogic = EndOfMonthSummaryBusinessLogic(serviceProvider: serviceProvider)

        todayViewModel = TodayViewModel(serviceProvider: serviceProvider,
                                        displayModel: HomeDisplayModel())

        feedTableViewModel = FeedTableViewModel()
        regularsTableViewModel = RegularsTableViewModel()
        balancesTableViewModel = BalancesTableViewModel(serviceProvider: serviceProvider)

        feedTableViewModel.inject(delegate: self)
        regularsTableViewModel.inject(delegate: self)
        balancesTableViewModel.inject(delegate: self)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShouldReloadNotification),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
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
        todayViewModel.inject(delegate: delegate)
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

    private func updateTransactionsTableViewModels() {
        feedTableViewModel.update(transactions: transactions)
        regularsTableViewModel.update(transactions: transactions)
    }

    private func updateTableViewModels() {
        updateTransactionsTableViewModels()

        if let endOfMonthSummaryList = endOfMonthSummaryList {
            balancesTableViewModel.update(endOfMonthSummaryList: endOfMonthSummaryList)
        }
    }

    private func setupDefaults() {
        todayViewModel.setupDefaults()

        transactions = Transaction.all(dataService: serviceProvider.dataService)
        let endOfMonthSummaries = EndOfMonthSummary.all(dataService: serviceProvider.dataService)

        guard let currentMonthSummary = CurrentMonthSummary.load(dataService: serviceProvider.dataService) else {
            return
        }

        endOfMonthSummaryList = EndOfMonthSummaryList(currentMonthSummary: currentMonthSummary,
                                                      endOfMonthSummaries: endOfMonthSummaries)
        updateTableViewModels()
    }

    @discardableResult private func updateData() -> Promise<Void> {
        return when(fulfilled: todayViewModel.getBalance(),
                    getUser(),
                    getExternalTransactions(),
                    getEndOfMonthSummaryList())
            .recover { error in
                self.delegate?.showError(message: error.localizedDescription)
        }
    }

    @discardableResult private func getUser() -> Promise<Void> {
        return todayViewModel.getUser()
            .done {
                self.serviceProvider.watchService.updateComplication()
        }
    }

    private func getExternalTransactions() -> Promise<Void> {
        return externalTransactionsBusinessLogic.getExternalTransactions()
            .done { transactions in
                self.transactions = transactions
                self.transactions.save(dataService: self.serviceProvider.dataService)
                self.updateTransactionsTableViewModels()
        }
    }

    private func delete(transaction: Transaction) {
        externalTransactionsBusinessLogic.delete(transaction: transaction).done {
            self.getUser()
            self.getEndOfMonthSummaryList()
            self.transactions = self.transactions.filter { $0.id != transaction.id }
            self.updateTransactionsTableViewModels()
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
        updateTransactionsTableViewModels()
    }

    func didUpdate(transaction: Transaction) {
        getUser()
        getEndOfMonthSummaryList()

        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
        updateTransactionsTableViewModels()
    }

}

extension HomeViewModel: SettingsViewModelDataDelegate {

    func didUpdate(user: User) {
        updateData()
    }

    func didReconcile() {
        updateData()
    }

}
