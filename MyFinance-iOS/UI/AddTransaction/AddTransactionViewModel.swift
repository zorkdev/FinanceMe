protocol AddTransactionViewModelDataDelegate: class {

    func didCreate(transaction: Transaction)

}

protocol AddTransactionViewModelDelegate: Dismissable, MessagePresentable {}

protocol AddTransactionViewModelType: ViewModelType {

    func shouldEnableSaveButton(displayModel: AddTransactionDisplayModel) -> Bool
    func saveButtonTapped(with displayModel: AddTransactionDisplayModel)
    func formatted(amount: String, original: String) -> String
    func numberOfComponentsInPickerView() -> Int
    func pickerViewNumberOfRowsIn(component: Int) -> Int
    func pickerViewTitle(for row: Int, for component: Int) -> String?

}

class AddTransactionViewModel {

    private let externalTransactionsBusinessLogic: ExternalTransactionsBusinessLogic

    let networkServiceProvider: NetworkServiceProvider

    private weak var delegate: AddTransactionViewModelDelegate?
    private weak var dataDelegate: AddTransactionViewModelDataDelegate?

    init(networkServiceProvider: NetworkServiceProvider,
         delegate: AddTransactionViewModelDelegate,
         dataDelegate: AddTransactionViewModelDataDelegate?) {
        self.networkServiceProvider = networkServiceProvider
        self.delegate = delegate
        self.dataDelegate = dataDelegate
        self.externalTransactionsBusinessLogic =
            ExternalTransactionsBusinessLogic(networkService: networkServiceProvider.networkService)
    }

}

// MARK: Interface

extension AddTransactionViewModel: AddTransactionViewModelType {

    func shouldEnableSaveButton(displayModel: AddTransactionDisplayModel) -> Bool {
        guard let amount = createAmount(from: displayModel.amount),
            amount != 0,
            displayModel.narrative.components(separatedBy: .whitespaces).joined() != "" else { return false }

        return  true
    }

    func saveButtonTapped(with displayModel: AddTransactionDisplayModel) {
        guard let amountAbs = createAmount(from: displayModel.amount) else { return }
        let source = TransactionSource.externalValues[displayModel.source]
        let amount = source.direction == .inbound ? amountAbs : -amountAbs

        let transaction = Transaction(amount: amount,
                                      direction: source.direction,
                                      created: displayModel.created,
                                      narrative: displayModel.narrative,
                                      source: source)
        save(transaction: transaction)
    }

    func formatted(amount: String, original: String) -> String {
        var amountTemp = amount

        if amountTemp.contains(Formatters.currencySymbol) == false {
            amountTemp.insert(Character(Formatters.currencySymbol), at: amountTemp.startIndex)
        } else if amountTemp == Formatters.currencySymbol {
            return ""
        }

        return validate(amount: amountTemp) ? amountTemp : original
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

}

// MARK: - Private methods

extension AddTransactionViewModel {

    private func validate(amount: String) -> Bool {
        return Validators.validate(amount: amount)
    }

    private func createAmount(from: String) -> Double? {
        let amountString = from
            .components(separatedBy: .whitespaces)
            .joined()
            .replacingOccurrences(of: Formatters.currencySymbol, with: "")

        return Double(amountString)
    }

    private func save(transaction: Transaction) {
        delegate?.showSpinner()
        externalTransactionsBusinessLogic.create(transaction: transaction)
            .done { transaction in
                self.dataDelegate?.didCreate(transaction: transaction)
                self.delegate?.showSuccess(message: AddTransactionDisplayModel.successMessage)
                self.delegate?.dismiss(self)
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
        }
    }

}
