protocol AddTransactionViewModelDataDelegate: class {

    func didCreate(transaction: Transaction)
    func didUpdate(transaction: Transaction)

}

protocol AddTransactionViewModelDelegate: TableViewModelDelegate, MessagePresentable {

    func updateSaveButton(enabled: Bool)

}

protocol AddTransactionViewModelType: ViewModelType {

    func viewWillAppear()
    func saveButtonTapped()
    func dismissTapped()

}

class AddTransactionViewModel: ServiceClient, TableViewModelType {

    enum State {
        case add, edit
    }

    typealias ServiceProvider = NavigatorProvider & NetworkServiceProvider
    let serviceProvider: ServiceProvider

    private let externalTransactionsBusinessLogic: ExternalTransactionsBusinessLogic
    private let state: State
    private let transaction: Transaction?

    private let amountModel: AmountInputCellModelForViewModelType
    private let descriptionModel: TextInputCellModelForViewModelType
    private let categoryModel: CategoryInputCellModelForViewModelType
    private let dateModel: DateInputCellModelForViewModelType

    private weak var delegate: AddTransactionViewModelDelegate?
    private weak var dataDelegate: AddTransactionViewModelDataDelegate?

    var sections = [TableViewSection]() {
        didSet {
            updateSections(new: sections, old: oldValue)
        }
    }

    var tableViewController: TableViewController?

    init(serviceProvider: ServiceProvider,
         dataDelegate: AddTransactionViewModelDataDelegate?,
         state: State = .add,
         transaction: Transaction? = nil) {
        self.serviceProvider = serviceProvider
        self.dataDelegate = dataDelegate
        self.externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(serviceProvider: serviceProvider)
        self.state = state
        self.transaction = transaction

        amountModel = AmountInputCellModel(label: AddTransactionDisplayModel.amountTitle)
        descriptionModel = TextInputCellModel(label: AddTransactionDisplayModel.descriptionTitle,
                                              placeholder: AddTransactionDisplayModel.descriptionPlaceholder)
        categoryModel = CategoryInputCellModel()
        dateModel = DateInputCellModel(label: AddTransactionDisplayModel.dateTitle, mode: .dateAndTime)

        amountModel.viewModelDelegate = self
        descriptionModel.viewModelDelegate = self
        categoryModel.categoryViewModelDelegate = self
        dateModel.viewModelDelegate = self
    }

}

// MARK: Interface

extension AddTransactionViewModel: AddTransactionViewModelType {

    func viewDidLoad() {
        setupTableView()
    }

    func viewWillAppear() {
        DispatchQueue.main.async {
            self.delegate?.updateSaveButton(enabled: self.isValid)
            (self.sections.first?.cellModels.first?.wrapped as? InputCellModelForViewModelType)?.becomeFirstResponder()
        }
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? AddTransactionViewModelDelegate else { return }
        self.delegate = delegate
    }

    func saveButtonTapped() {
        guard let amountAbs = amountModel.currentValue,
            let narrative = descriptionModel.currentValue else { return }

        let source = categoryModel.currentCategoryValue
        let amount = source.direction == .inbound ? amountAbs : -amountAbs
        let created = dateModel.currentValue

        switch state {
        case .add:
            let transaction = Transaction(amount: amount,
                                          direction: source.direction,
                                          created: created,
                                          narrative: narrative,
                                          source: source)
            save(transaction: transaction)

        case .edit:
            guard var transaction = transaction else { return }
            transaction.amount = amount
            transaction.direction = source.direction
            transaction.created = created
            transaction.narrative = narrative
            transaction.source = source

            update(transaction: transaction)
        }

    }

    func dismissTapped() {
        serviceProvider.navigator.dismiss()
    }

}

extension AddTransactionViewModel: InputCellModelViewModelDelegate {

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool { return true }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType { return .done }

    func didChangeValue() {
        delegate?.updateSaveButton(enabled: isValid)
    }

}

extension AddTransactionViewModel: AmountInputCellModelViewModelDelegate {}
extension AddTransactionViewModel: TextInputCellModelViewModelDelegate {}
extension AddTransactionViewModel: CategoryInputCellModelViewModelDelegate {}
extension AddTransactionViewModel: DateInputCellModelViewModelDelegate {

    func defaultValue(amountCell: AmountInputCellModelForViewModelType) -> Double? {
        return transaction?.amount
    }

    func defaultValue(textCell: TextInputCellModelForViewModelType) -> String? {
        return transaction?.narrative
    }

    func defaultValue(categoryCell: CategoryInputCellModelForViewModelType) -> TransactionSource {
        return transaction?.source ?? TransactionSource.externalValues[0]
    }

    func defaultValue(dateCell: DateInputCellModelForViewModelType) -> Date {
        return transaction?.created ?? Date()
    }

}

// MARK: - Private methods

extension AddTransactionViewModel {

    private func setupTableView() {
        sections = [TableViewSection(cellModels: [amountModel.wrap,
                                                  descriptionModel.wrap,
                                                  categoryModel.wrap,
                                                  dateModel.wrap])]

        guard let tableView = delegate?.tableView else { return }

        tableViewController = TableViewController(tableView: tableView,
                                                  cells: [InputTableViewCell.self],
                                                  viewModel: self)
        tableViewController?.updateCells()
    }

    private func save(transaction: Transaction) {
        delegate?.showSpinner()
        externalTransactionsBusinessLogic.create(transaction: transaction)
            .done { transaction in
                self.dataDelegate?.didCreate(transaction: transaction)
                self.delegate?.showSuccess(message: AddTransactionDisplayModel.successMessage)
                self.serviceProvider.navigator.dismiss()
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
        }
    }

    private func update(transaction: Transaction) {
        delegate?.showSpinner()
        externalTransactionsBusinessLogic.update(transaction: transaction)
            .done { transaction in
                self.dataDelegate?.didUpdate(transaction: transaction)
                self.delegate?.showSuccess(message: AddTransactionDisplayModel.successMessage)
                self.serviceProvider.navigator.dismiss()
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
        }
    }

}
