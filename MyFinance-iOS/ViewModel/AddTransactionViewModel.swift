struct AddTransactionDisplayModel {

    static let buttonEnabledAlpha: CGFloat = 1.0
    static let buttonDisabledAlpha: CGFloat = 0.5
    static let buttonAnimationDuration = 0.2

    let amount: String
    let narrative: String
    let source: Int
    let created: Date

    static func dateString(from date: Date) -> String {
        return Formatters.dateTime.string(from: date)
    }

}

protocol AddTransactionViewModelDataDelegate: class {

    func didCreate(transaction: Transaction)

}

class AddTransactionViewModel: ViewModelType {

    private let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()

    private weak var delegate: Dismissable?
    private weak var dataDelegate: AddTransactionViewModelDataDelegate?

    init(delegate: Dismissable, dataDelegate: AddTransactionViewModelDataDelegate?) {
        self.delegate = delegate
        self.dataDelegate = dataDelegate
    }

    func shouldEnableSaveButton(displayModel: AddTransactionDisplayModel) -> Bool {
        guard let amount = createAmount(from: displayModel.amount),
            amount != 0,
            displayModel.narrative.components(separatedBy: .whitespaces).joined() != "" else { return false }

        return  true
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

    func validate(amount: String) -> Bool {
        return Validators.validate(amount: amount)
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

    private func createAmount(from: String) -> Double? {
        let amountString = from
            .components(separatedBy: .whitespaces)
            .joined()
            .replacingOccurrences(of: Formatters.currencySymbol, with: "")

        return Double(amountString)
    }

    private func save(transaction: Transaction) {
        externalTransactionsBusinessLogic.create(transaction: transaction)
            .then { transaction -> Void in
                self.dataDelegate?.didCreate(transaction: transaction)
                self.delegate?.dismiss(self)
            }.catch { error in
                print(error)
        }
    }

}

extension AddTransactionViewModel {

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
