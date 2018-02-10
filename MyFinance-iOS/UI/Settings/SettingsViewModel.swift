protocol SettingsViewModelDataDelegate: class {

    func didUpdateUser()

}

protocol SettingsViewModelDelegate: Dismissable {

    func setupDefault(displayModel: SettingsDisplayModel)
    func update(editing: Bool)

}

protocol SettingsViewModelType: ViewModelType {

    func shouldEnableSaveButton(displayModel: SettingsDisplayModel) -> Bool
    func editButtonTapped()
    func saveButtonTapped(with displayModel: SettingsDisplayModel)
    func formatted(amount: String, original: String) -> String
    func numberOfComponentsInPickerView() -> Int
    func pickerViewNumberOfRowsIn(component: Int) -> Int
    func pickerViewTitle(for row: Int, for component: Int) -> String?
    func pickerViewRowInComponent(for payday: String) -> (row: Int, component: Int)

}

class SettingsViewModel {

    private let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()

    private let paydayValues: [String] = {
        return Array(1...28).map { "\($0)" }
    }()

    private var isEditing = false

    private weak var delegate: SettingsViewModelDelegate?
    private weak var dataDelegate: SettingsViewModelDataDelegate?

    init(delegate: SettingsViewModelDelegate, dataDelegate: SettingsViewModelDataDelegate?) {
        self.delegate = delegate
        self.dataDelegate = dataDelegate
    }

}

// MARK: Interface

extension SettingsViewModel: SettingsViewModelType {

    func viewDidLoad() {
        guard let user = User.load(),
        let largeTransaction = Formatters.currency
            .string(from: NSNumber(value: user.largeTransaction)) else { return }

        let displayModel = SettingsDisplayModel(name: user.name,
                                                largeTransaction: largeTransaction,
                                                payday: "\(user.payday)",
                                                startDate: user.startDate)

        delegate?.setupDefault(displayModel: displayModel)
        delegate?.update(editing: isEditing)
    }

    func shouldEnableSaveButton(displayModel: SettingsDisplayModel) -> Bool {
        guard let largeTransaction = createAmount(from: displayModel.largeTransaction),
            largeTransaction != 0,
            displayModel.name.components(separatedBy: .whitespaces).joined() != "" else { return false }

        return  true
    }

    func editButtonTapped() {
        isEditing = !isEditing
        delegate?.update(editing: isEditing)
    }

    func saveButtonTapped(with displayModel: SettingsDisplayModel) {
        guard let largeTransaction = createAmount(from: displayModel.largeTransaction),
            let payday = Int(displayModel.payday) else { return }

        let user = User(name: displayModel.name,
                        payday: payday,
                        startDate: displayModel.startDate,
                        largeTransaction: largeTransaction)
        save(user: user)
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
        return paydayValues.count
    }

    func pickerViewTitle(for row: Int, for component: Int) -> String? {
        return paydayValues[row]
    }

    func pickerViewRowInComponent(for payday: String) -> (row: Int, component: Int) {
        return ((paydayValues.index(of: payday) ?? 0), 0)
    }

}

// MARK: - Private methods

extension SettingsViewModel {

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

    private func save(user: User) {
//        externalTransactionsBusinessLogic.create(transaction: transaction)
//            .then { transaction -> Void in
//                self.dataDelegate?.didCreate(transaction: transaction)
//                self.delegate?.dismiss(self)
//            }.catch { error in
//                print(error)
//        }
    }

}
