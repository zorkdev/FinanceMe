protocol LoginViewModelDelegate: TableViewModelDelegate, MessagePresentable {

    func updateLoginButton(enabled: Bool)

}

protocol LoginViewModelType: ViewModelType {

    func loginButtonTapped()

}

class LoginViewModel: ServiceClient, TableViewModelType {

    typealias ServiceProvider = NavigatorProvider
        & NetworkServiceProvider
        & DataServiceProvider
        & SessionServiceProvider

    let serviceProvider: ServiceProvider

    private let userBusinessLogic: UserBusinessLogic

    private let emailModel: TextInputCellModelForViewModelType
    private let passwordModel: TextInputCellModelForViewModelType

    private weak var delegate: LoginViewModelDelegate?

    var sections = [TableViewSection]() {
        didSet {
            updateSections(new: sections, old: oldValue)
        }
    }

    var tableViewController: TableViewController?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
        self.userBusinessLogic = UserBusinessLogic(serviceProvider: serviceProvider)

        emailModel = EmailInputCellModel()
        passwordModel = SecureTextInputCellModel(label: LoginDisplayModel.passwordTitle)

        emailModel.viewModelDelegate = self
        passwordModel.viewModelDelegate = self
    }

}

// MARK: - Interface

extension LoginViewModel: LoginViewModelType {

    func viewDidLoad() {
        setupTableView()
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? LoginViewModelDelegate else { return }
        self.delegate = delegate
    }

    func loginButtonTapped() {
        guard let email = emailModel.currentValue,
            let password = passwordModel.currentValue else { return }

        let credentials = Credentials(email: email,
                                      password: password)
        login(credentials: credentials)
    }

    func didFinishLoadingTableView() {
        delegate?.updateLoginButton(enabled: isValid)
        (sections.first?.cellModels.first?.wrapped as? InputCellModelForViewModelType)?.becomeFirstResponder()
    }

}

extension LoginViewModel: TextInputCellModelViewModelDelegate {

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool { return true }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType { return .done }

    func didChangeValue() {
        delegate?.updateLoginButton(enabled: isValid)
    }

    func defaultValue(textCell: TextInputCellModelForViewModelType) -> String? { return nil }

}

// MARK: - Private methods

extension LoginViewModel {

    private func setupTableView() {
        sections = [TableViewSection(cellModels: [emailModel.wrap, passwordModel.wrap])]

        guard let tableView = delegate?.tableView else { return }

        tableViewController = TableViewController(tableView: tableView,
                                                  cells: [InputTableViewCell.self],
                                                  viewModel: self)
    }

    private func clearFields() {
        emailModel.update(value: "")
        passwordModel.update(value: "")
    }

    private func login(credentials: Credentials) {
        delegate?.showSpinner()
        userBusinessLogic.getSession(credentials: credentials)
            .done { _ in
                self.serviceProvider.navigator.popToRoot()
                self.clearFields()
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
        }
    }

}
