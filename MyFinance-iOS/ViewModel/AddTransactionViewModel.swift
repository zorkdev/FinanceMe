struct AddTransactionDisplayModel {

    let amount: String
    let narrative: String
    let source: Int
    let created: Date

}

protocol AddTransactionViewModelDataDelegate: class {

    func didCreate(transaction: Transaction)

}

class AddTransactionViewModel: ViewModelType {

    private let transactionsBusinessLogic = TransactionsBusinessLogic()

    private weak var delegate: Dismissable?
    private weak var dataDelegate: AddTransactionViewModelDataDelegate?

    init(delegate: Dismissable, dataDelegate: AddTransactionViewModelDataDelegate?) {
        self.delegate = delegate
        self.dataDelegate = dataDelegate
    }

    func saveButtonTapped(with displayModel: AddTransactionDisplayModel) {
        let amountString = displayModel.amount
            .components(separatedBy: .whitespaces)
            .joined()
        guard let amountAbs = Double(amountString) else { return }
        let source = TransactionSource.externalValues[displayModel.source]
        let amount = source.direction == .inbound ? amountAbs : -amountAbs

        let transaction = Transaction(amount: amount,
                                      direction: source.direction,
                                      created: displayModel.created,
                                      narrative: displayModel.narrative,
                                      source: source)
        save(transaction: transaction)
    }

    private func save(transaction: Transaction) {
        transactionsBusinessLogic.create(transaction: transaction)
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
        return TransactionSource.externalValues[row].rawValue
    }

}
