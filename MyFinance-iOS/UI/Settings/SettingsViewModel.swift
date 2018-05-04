protocol SettingsViewModelDataDelegate: class {

    func didUpdate(user: User)

}

protocol SettingsViewModelDelegate: TableViewModelDelegate, MessagePresentable {

    func updateButtons(enabled: Bool, editing: Bool)

}

protocol SettingsViewModelType: ViewModelType {

    var saveButtonTitle: String { get }
    var editButtonTitle: String { get }

    func viewWillAppear()
    func saveButtonTapped()
    func editButtonTapped()
    func dismissTapped()

}

class SettingsViewModel: ServiceClient, TableViewModelType {

    typealias ServiceProvider = NavigatorProvider
        & NetworkServiceProvider
        & DataServiceProvider
        & SessionServiceProvider

    let serviceProvider: ServiceProvider

    private let userBusinessLogic: UserBusinessLogic

    private var isEditing = false

    private let nameModel: TextInputCellModelForViewModelType
    private let amountLimitModel: AmountInputCellModelForViewModelType
    private let paydayModel: PaydayInputCellModelForViewModelType
    private let startDateModel: DateInputCellModelForViewModelType

    private weak var delegate: SettingsViewModelDelegate?
    private weak var dataDelegate: SettingsViewModelDataDelegate?

    var sections = [TableViewSection]() {
        didSet {
            updateSections(new: sections, old: oldValue)
        }
    }

    var tableViewController: TableViewController?

    init(serviceProvider: ServiceProvider,
         dataDelegate: SettingsViewModelDataDelegate?) {
        self.serviceProvider = serviceProvider
        self.dataDelegate = dataDelegate
        self.userBusinessLogic = UserBusinessLogic(serviceProvider: serviceProvider)

        nameModel = TextInputCellModel(label: "Name", placeholder: "John")
        amountLimitModel = AmountInputCellModel(label: "Amount Limit")
        paydayModel = PaydayInputCellModel()
        startDateModel = DateInputCellModel(label: "Start Date", mode: .date)

        nameModel.viewModelDelegate = self
        amountLimitModel.viewModelDelegate = self
        paydayModel.paydayViewModelDelegate = self
        startDateModel.viewModelDelegate = self
    }

}

// MARK: Interface

extension SettingsViewModel: SettingsViewModelType {

    var saveButtonTitle: String {
        return isEditing ? SettingsDisplayModel.saveButtonTitle : SettingsDisplayModel.logOutButtonTitle
    }

    var editButtonTitle: String {
        return isEditing ? SettingsDisplayModel.cancelButtonTitle : SettingsDisplayModel.editButtonTitle
    }

    func viewDidLoad() {
        setupTableView()
    }

    func viewWillAppear() {
        DispatchQueue.main.async {
            self.updateButtons()
        }
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? SettingsViewModelDelegate else { return }
        self.delegate = delegate
    }

    func editButtonTapped() {
        isEditing = !isEditing
        if isEditing == false { setupDefaults() }
        tableViewController?.updateCells()
        updateButtons()
    }

    func saveButtonTapped() {
        if isEditing {
            guard let name = nameModel.currentValue,
                let largeTransaction = amountLimitModel.currentValue else { return }

            let payday = paydayModel.currentPaydayValue.intValue
            let startDate = startDateModel.currentValue

            let user = User(name: name,
                            payday: payday,
                            startDate: startDate,
                            largeTransaction: largeTransaction)
            save(user: user)

        } else {
            logOut()
        }
    }

    func dismissTapped() {
        serviceProvider.navigator.dismiss()
    }

}

extension SettingsViewModel: InputCellModelViewModelDelegate {

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool {
        return isEditing
    }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType { return .done }

    func didChangeValue() {
        updateButtons()
    }

}

extension SettingsViewModel: AmountInputCellModelViewModelDelegate {}
extension SettingsViewModel: TextInputCellModelViewModelDelegate {}
extension SettingsViewModel: PaydayInputCellModelViewModelDelegate {}
extension SettingsViewModel: DateInputCellModelViewModelDelegate {

    func defaultValue(amountCell: AmountInputCellModelForViewModelType) -> Double? {
        return User.load(dataService: serviceProvider.dataService)?.largeTransaction ?? 0
    }

    func defaultValue(textCell: TextInputCellModelForViewModelType) -> String? {
        return User.load(dataService: serviceProvider.dataService)?.name
    }

    func defaultValue(paydayCell: PaydayInputCellModelForViewModelType) -> Payday {
        guard let payday = User.load(dataService: serviceProvider.dataService)?.payday else {
            return Paydays.values[0]
        }
        return Payday(intValue: payday)
    }

    func defaultValue(dateCell: DateInputCellModelForViewModelType) -> Date {
        return User.load(dataService: serviceProvider.dataService)?.startDate ?? Date()
    }

}

// MARK: - Private methods

extension SettingsViewModel {

    private func setupTableView() {
        sections = [TableViewSection(cellModels: [nameModel.wrap,
                                                  amountLimitModel.wrap,
                                                  paydayModel.wrap,
                                                  startDateModel.wrap])]

        guard let tableView = delegate?.tableView else { return }

        tableViewController = TableViewController(tableView: tableView,
                                                  cells: [InputTableViewCell.self],
                                                  viewModel: self)
        tableViewController?.updateCells()
    }

    private func setupDefaults() {
        guard let user = User.load(dataService: serviceProvider.dataService) else { return }

        nameModel.update(value: user.name)
        amountLimitModel.update(value: user.largeTransaction)
        paydayModel.update(payday: Payday(intValue: user.payday))
        startDateModel.update(value: user.startDate)
    }

    private func updateButtons() {
        let enabled = isEditing ? isValid : true
        delegate?.updateButtons(enabled: enabled, editing: isEditing)
    }

    private func logOut() {
        serviceProvider.dataService.removeAll()
        serviceProvider.navigator.popToRoot()
    }

    private func save(user: User) {
        delegate?.showSpinner()
        userBusinessLogic.update(user: user)
            .done { user in
                self.dataDelegate?.didUpdate(user: user)
                self.delegate?.showSuccess(message: SettingsDisplayModel.successMessage)
                self.serviceProvider.navigator.dismiss()
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
        }
    }

}
