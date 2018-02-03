protocol HomeViewModelDelegate: TodayViewModelDelegate {

    func reloadTableView()

}

class HomeViewModel: TodayPresentable {

    private enum Tab: Int {
        case transactions = 0, bills
    }

    private let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()
    private var externalTransactions = [Transaction]()
    private var filteredTransactions = [Transaction]()

    private var currentTab = Tab.transactions {
        didSet {
            updateTransactions()
        }
    }

    let displayModel: TodayDisplayModelType = HomeDisplayModel()

    weak var delegate: TodayViewModelDelegate?

    var cellModels = [HomeCellModel]()

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        setupDefaults()
        updateData()
        getExternalTransactions()
    }

    func segmentedControlValueChanged(value: Int) {
        guard let tab = Tab(rawValue: value) else { return }
        currentTab = tab
    }

}

// MARK: - Private methods

extension HomeViewModel {

    private func updateTransactions() {
        switch currentTab {
        case .transactions:
            filteredTransactions = externalTransactions
                .filter {
                    $0.source == .externalInbound ||
                    $0.source == .externalOutbound
                }
                .sorted(by: { $0.created > $1.created })

        case .bills:
            filteredTransactions = externalTransactions
                .filter {
                    $0.source == .externalRegularInbound ||
                    $0.source == .externalRegularOutbound
                }
                .sorted(by: { $0.amount > $1.amount })
        }
        configureCellModels()
        (delegate as? HomeViewModelDelegate)?.reloadTableView()
    }

    private func configureCellModels() {
        cellModels = []

        for transaction in filteredTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let cellModel = HomeCellModel(title: title, detail: detail)
            cellModels.append(cellModel)
        }
    }

    private func getExternalTransactions() {
        externalTransactionsBusinessLogic.getExternalTransactions().then { transactions -> Void in
            self.externalTransactions = transactions
            self.updateTransactions()
        }.catch { error in
            print(error)
        }
    }

}

extension HomeViewModel: AddTransactionViewModelDataDelegate {

    func didCreate(transaction: Transaction) {
        externalTransactions.append(transaction)
        updateTransactions()
    }

}
