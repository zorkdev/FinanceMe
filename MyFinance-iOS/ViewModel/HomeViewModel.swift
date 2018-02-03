protocol HomeViewModelDelegate: TodayViewModelDelegate {

    func reloadTableView()
    func delete(from tab: HomeViewModel.Tab, section: Int)
    func delete(from tab: HomeViewModel.Tab, section: Int, row: Int)
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

    enum RegularsSection: Int {
        case inbound, outbound
    }

    private let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()

    private var externalTransactions = [Transaction]() {
        didSet {
            DataManager.shared.transactions = externalTransactions
        }
    }

    private var normalTransactions = [Transaction]()
    private var regularTransactions = [Transaction]()

    let displayModel: TodayDisplayModelType = HomeDisplayModel()

    weak var delegate: TodayViewModelDelegate?

    var normalCellModels = [Date: [HomeCellModel]]()
    var regularCellModels = [RegularsSection: [HomeCellModel]]()

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        setupDefaults()
        updateData()
        getExternalTransactions()
    }

    func setupDefaults() {
        let balanceAttributedString = createAttributedString(from: DataManager.shared.balance)
        let allowanceAttributedString = createAttributedString(from: DataManager.shared.allowance)
        delegate?.set(balance: balanceAttributedString)
        delegate?.set(allowance: allowanceAttributedString)

        externalTransactions = DataManager.shared.transactions
        updateTransactions()
        (delegate as? HomeViewModelDelegate)?.reloadTableView()
    }

    func numberOfSections(in tab: Tab) -> Int {
        switch tab {
        case .transactions: return normalCellModels.count
        case .bills: return 2
        }
    }

    func numberOfRows(in tab: Tab, in section: Int) -> Int {
        switch tab {
        case .transactions:
            let key = normalCellModels.keys.sorted(by: { $0 > $1 })[section]
            return normalCellModels[key]?.count ?? 0
        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return 0 }
            switch section {
            case .inbound: return regularCellModels[.inbound]?.count ?? 0
            case .outbound: return regularCellModels[.outbound]?.count ?? 0
            }
        }
    }

    func cellModel(for tab: Tab, section: Int, row: Int) -> HomeCellModel? {
        switch tab {
        case .transactions:
            let key = normalCellModels.keys.sorted(by: { $0 > $1 })[section]
            return normalCellModels[key]?[row]
        case .bills:
            guard let section = RegularsSection(rawValue: section) else { return nil }
            switch section {
            case .inbound: return regularCellModels[.inbound]?[row]
            case .outbound: return regularCellModels[.outbound]?[row]
            }
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
            case .inbound: return HomeDisplayModel.regularInboundSectionTitle
            case .outbound: return HomeDisplayModel.regularOutboundSectionTitle
            }
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
            case .inbound:
                transaction = regularTransactions
                    .filter({ $0.source == .externalRegularInbound })[row]
            case .outbound:
                transaction = regularTransactions
                    .filter({ $0.source == .externalRegularOutbound })[row]
            }
            shouldDeleteSection = regularCellModels[section]?.count == 1
        }

        let row = shouldDeleteSection ? nil : row

        (delegate as? HomeViewModelDelegate)?
            .showAlert(with: HomeDisplayModel.DeleteAlert.title,
                       message: HomeDisplayModel.DeleteAlert.message,
                       confirmActionTitle: HomeDisplayModel.DeleteAlert.confirmButtonTitle,
                       confirmAction: { self.delete(transaction: transaction,
                                                    section: section,
                                                    row: row) },
                       cancelActionTitle: HomeDisplayModel.DeleteAlert.cancelButtonTitle)
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

    private func configureCellModels() {
        normalCellModels = [:]
        regularCellModels = [:]

        for transaction in normalTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let detailColor = transaction.amount > 0 ?
                HomeCellModel.positiveColor : HomeCellModel.negativeColor
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

        for transaction in regularTransactions {
            let title = transaction.narrative
            let detail = Formatters.currencyPlusSign
                .string(from: NSNumber(value: transaction.amount))
                ?? displayModel.defaultAmount
            let detailColor = transaction.amount > 0 ?
                HomeCellModel.positiveColor : HomeCellModel.negativeColor
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

    private func delete(transaction: Transaction, section: Int, row: Int?) {
        externalTransactionsBusinessLogic.delete(transaction: transaction).then { _ -> Void in
            self.getUser()
            self.externalTransactions = self.externalTransactions.filter { $0.id != transaction.id }
            self.updateTransactions()
            switch transaction.source {
            case .externalInbound, .externalOutbound:
                if let row = row {
                    (self.delegate as? HomeViewModelDelegate)?.delete(from: .transactions,
                                                                      section: section,
                                                                      row: row)
                } else {
                    (self.delegate as? HomeViewModelDelegate)?.delete(from: .transactions,
                                                                      section: section)
                }
            case .externalRegularInbound, .externalRegularOutbound:
                if let row = row {
                    (self.delegate as? HomeViewModelDelegate)?.delete(from: .bills,
                                                                      section: section,
                                                                      row: row)
                } else {
                    (self.delegate as? HomeViewModelDelegate)?.delete(from: .bills,
                                                                      section: section)
                }
            default: break
            }
        }
    }

}

extension HomeViewModel: AddTransactionViewModelDataDelegate {

    func didCreate(transaction: Transaction) {
        getUser()
        externalTransactions.append(transaction)
        updateTransactions()
        (delegate as? HomeViewModelDelegate)?.reloadTableView()
    }

}
