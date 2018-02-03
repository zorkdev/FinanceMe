struct AddTransactionDisplayModel {

    let amount: String
    let narrative: String
    let source: Int
    let created: Date

}

protocol AddTransactionViewModelDelegate: Dismissable {}

class AddTransactionViewModel: ViewModelType {

    private let transactionsBusinessLogic = TransactionsBusinessLogic()

    private weak var delegate: AddTransactionViewModelDelegate?

    init(delegate: AddTransactionViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {

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
        transactionsBusinessLogic.create(transaction: transaction).then { _ in
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
