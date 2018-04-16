protocol AddTransactionViewModelDataDelegate: class {

    func didCreate(transaction: Transaction)
    func didUpdate(transaction: Transaction)

}

protocol AddTransactionViewModelDelegate: ViewModelDelegate & MessagePresentable {

    func update(displayModel: AddTransactionDisplayModel)

}

protocol AddTransactionViewModelType: ViewModelType {

    func shouldEnableSaveButton(displayModel: AddTransactionDisplayModel) -> Bool
    func saveButtonTapped(with displayModel: AddTransactionDisplayModel)
    func formatted(amount: String, original: String) -> String
    func numberOfComponentsInPickerView() -> Int
    func pickerViewNumberOfRowsIn(component: Int) -> Int
    func pickerViewTitle(for row: Int, for component: Int) -> String?
    func dismissTapped()

}

class AddTransactionViewModel: ServiceClient {

    enum State {
        case add, edit
    }

    typealias ServiceProvider = NavigatorProvider & NetworkServiceProvider
    let serviceProvider: ServiceProvider

    private let externalTransactionsBusinessLogic: ExternalTransactionsBusinessLogic
    private let state: State
    private let transaction: Transaction?

    private weak var delegate: AddTransactionViewModelDelegate?
    private weak var dataDelegate: AddTransactionViewModelDataDelegate?

    init(serviceProvider: ServiceProvider,
         dataDelegate: AddTransactionViewModelDataDelegate?,
         state: State = .add,
         transaction: Transaction? = nil) {
        self.serviceProvider = serviceProvider
        self.dataDelegate = dataDelegate
        self.externalTransactionsBusinessLogic =
            ExternalTransactionsBusinessLogic(networkService: serviceProvider.networkService)
        self.state = state
        self.transaction = transaction
    }

}

// MARK: Interface

extension AddTransactionViewModel: AddTransactionViewModelType {

    func viewDidLoad() {
        if state == .edit, let transaction = transaction {
            let displayModel = createDisplayModel(transaction: transaction)
            delegate?.update(displayModel: displayModel)
        }
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? AddTransactionViewModelDelegate else { return }
        self.delegate = delegate
    }

    func shouldEnableSaveButton(displayModel: AddTransactionDisplayModel) -> Bool {
        guard let amount = Formatters.createAmount(from: displayModel.amount),
            amount != 0,
            displayModel.narrative.components(separatedBy: .whitespaces).joined() != "" else { return false }

        return  true
    }

    func saveButtonTapped(with displayModel: AddTransactionDisplayModel) {
        guard let amountAbs = Formatters.createAmount(from: displayModel.amount) else { return }
        let source = TransactionSource.externalValues[displayModel.source]
        let amount = source.direction == .inbound ? amountAbs : -amountAbs

        switch state {
        case .add:
            let transaction = Transaction(amount: amount,
                                          direction: source.direction,
                                          created: displayModel.created,
                                          narrative: displayModel.narrative,
                                          source: source)
            save(transaction: transaction)

        case .edit:
            guard var transaction = transaction else { return }
            transaction.amount = amount
            transaction.direction = source.direction
            transaction.created = displayModel.created
            transaction.narrative = displayModel.narrative
            transaction.source = source

            update(transaction: transaction)
        }

    }

    func formatted(amount: String, original: String) -> String {
        let sanitisedAmount = Formatters.sanitise(amount: amount)

        return validate(amount: sanitisedAmount) ? sanitisedAmount : original
    }

    func numberOfComponentsInPickerView() -> Int {
        return 1
    }

    func pickerViewNumberOfRowsIn(component: Int) -> Int {
        return TransactionSource.externalValues.count
    }

    func pickerViewTitle(for row: Int, for component: Int) -> String? {
        return TransactionSource.externalValues[row].displayString
    }

    func dismissTapped() {
        serviceProvider.navigator.dismiss()
    }

}

// MARK: - Private methods

extension AddTransactionViewModel {

    private func validate(amount: String) -> Bool {
        return Validators.validate(amount: amount)
    }

    private func createDisplayModel(transaction: Transaction) -> AddTransactionDisplayModel {
        let amount = Formatters.currencyNoSign.string(from: NSNumber(value: transaction.amount))!
        let source = TransactionSource.externalValues.index(of: transaction.source)!

        return AddTransactionDisplayModel(amount: amount,
                                          narrative: transaction.narrative,
                                          source: source,
                                          created: transaction.created)
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
