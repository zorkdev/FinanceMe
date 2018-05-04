class LoginViewController: BaseViewController, KeyboardManageable, TableViewContainer {

    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        viewModel.loginButtonTapped()
    }

}

extension LoginViewController: LoginViewModelDelegate {

    func updateLoginButton(enabled: Bool) {
        loginButton.isEnabled = enabled

        UIView.animate(withDuration: LoginDisplayModel.buttonAnimationDuration) {
            self.loginButton.alpha = enabled ? LoginDisplayModel.buttonEnabledAlpha :
                                               LoginDisplayModel.buttonDisabledAlpha
        }
    }

}

extension LoginViewController: ViewModelInjectable {

    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? LoginViewModelType else { return }
        self.viewModel = viewModel
    }

}
