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
        & PushNotificationServiceProvider

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

    var tableViewController: TableViewControllerType?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider

        userBusinessLogic = UserBusinessLogic(serviceProvider: serviceProvider)

        emailModel = EmailInputCellModel()
        passwordModel = SecureTextInputCellModel(label: LoginDisplayModel.passwordTitle)

        sections = [TableViewSection(cellModels: [emailModel.wrap, passwordModel.wrap])]

        emailModel.viewModelDelegate = self
        passwordModel.viewModelDelegate = self
    }
}

// MARK: - Interface

extension LoginViewModel: LoginViewModelType {
    func viewDidLoad() {
        guard let tableView = delegate?.tableView else { return }
        setup(tableView: tableView, cells: [InputTableViewCell.self])
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
        becomeFirstResponder()
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
    private func login(credentials: Credentials) {
        delegate?.showSpinner()
        userBusinessLogic.getSession(credentials: credentials)
            .done { _ in
                self.serviceProvider.pushNotificationService.registerForNotifications()
                self.serviceProvider.navigator.popToRoot()
            }.catch { error in
                self.delegate?.showError(message: error.localizedDescription)
            }.finally {
                self.delegate?.hideSpinner()
            }
    }
}
