protocol HomeViewModelDelegate: TodayViewModelDelegate {

    func reloadTableView()
    func delete(at index: Int, from tab: HomeViewModel.Tab)
    func showAlert(with title: String,
                   message: String,
                   confirmActionTitle: String,
                   confirmAction: @escaping () -> Void,
                   cancelActionTitle: String)

}

class HomeViewModel: TodayPresentable {

    enum Tab: Int {
        case transactions = 0, bills
    }

    private let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()
    private var externalTransactions = [Transaction]()
    private var normalTransactions = [Transaction]()
    private var regularTransactions = [Transaction]()

    let displayModel: TodayDisplayModelType = HomeDisplayModel()

    weak var delegate: TodayViewModelDelegate?

    var normalCellModels = [HomeCellModel]()
    var regularCellModels = [HomeCellModel]()

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        setupDefaults()
        updateData()
        getExternalTransactions()
    }

    func delete(at index: Int, from tab: Tab) {
        let transaction: Transaction

        switch tab {
        case .transactions:
            transaction = normalTransactions[index]
        case .bills:
            transaction = regularTransactions[index]
        }

        (delegate as? HomeViewModelDelegate)?
            .showAlert(with: "Are you sure?",
                       message: "The transaction will be deleted.",
                       confirmActionTitle: "Delete",
                       confirmAction: { self.delete(transaction: transaction, at: index) },
                       cancelActionTitle: "Cancel")
    }

}

// MARK: - Private methods

extension HomeViewModel {

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
            .sorted(by: { $0.amount > $1.amount })

        configureCellModels()
    }

    private func configureCellModels() {
        normalCellModels = []
        regularCellModels = []

        for transaction in normalTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let cellModel = HomeCellModel(title: title, detail: detail)
            normalCellModels.append(cellModel)
        }

        for transaction in regularTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let cellModel = HomeCellModel(title: title, detail: detail)
            regularCellModels.append(cellModel)
        }
    }

    private func getExternalTransactions() {
        externalTransactionsBusinessLogic.getExternalTransactions().then { transactions -> Void in
            self.externalTransactions = transactions
            self.updateTransactions()
            (self.delegate as? HomeViewModelDelegate)?.reloadTableView()
        }.catch { error in
            print(error)
        }
    }

    private func delete(transaction: Transaction, at index: Int) {
        externalTransactionsBusinessLogic.delete(transaction: transaction).then { _ -> Void in
            self.externalTransactions = self.externalTransactions.filter { $0.id != transaction.id }
            self.updateTransactions()
            switch transaction.source {
            case .externalInbound, .externalOutbound:
                (self.delegate as? HomeViewModelDelegate)?.delete(at: index,
                                                                  from: .transactions)
            case .externalRegularInbound, .externalRegularOutbound:
                (self.delegate as? HomeViewModelDelegate)?.delete(at: index,
                                                                  from: .bills)
            default: break
            }
        }
    }

}

extension HomeViewModel: AddTransactionViewModelDataDelegate {

    func didCreate(transaction: Transaction) {
        externalTransactions.append(transaction)
        updateTransactions()
        (delegate as? HomeViewModelDelegate)?.reloadTableView()
    }

}
