class LoginViewController: BaseViewController {

    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginViewModelType!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLoginButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.viewDidAppear()
    }

    private func updateLoginButton() {
        let loginDisplayModel = LoginDisplayModel(email: emailField.text ?? "",
                                                  password: passwordField.text ?? "")

        let shouldEnable = viewModel.shouldEnableLoginButton(displayModel: loginDisplayModel)

        loginButton.isEnabled = shouldEnable

        UIView.animate(withDuration: LoginDisplayModel.buttonAnimationDuration) {
            self.loginButton.alpha = shouldEnable ? LoginDisplayModel.buttonEnabledAlpha :
                LoginDisplayModel.buttonDisabledAlpha
        }
    }

    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailField.text,
            email.components(separatedBy: .whitespaces)
                .joined() != "",
            let password = passwordField.text,
            password.components(separatedBy: .whitespaces)
                .joined() != "" else { return }

        let loginDisplayModel = LoginDisplayModel(email: email,
                                                  password: password)

        viewModel.loginButtonTapped(with: loginDisplayModel)
    }

}

extension LoginViewController: LoginViewModelDelegate {

    func clearFields() {
        emailField.text = nil
        passwordField.text = nil
    }

}

extension LoginViewController: ViewModelInjectable {

    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? LoginViewModelType else { return }
        self.viewModel = viewModel
    }

}

extension LoginViewController {

    @IBAction private func textFieldValueChanged(_ sender: UITextField) {
        updateLoginButton()
    }

    private func textField(_ textField: UITextField,
                           shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool {
        guard textField == emailField,
            let originalText = textField.text,
            let range = Range(range, in: originalText)  else { return true }

        let text = originalText.replacingCharacters(in: range, with: string)

        return viewModel.validate(email: text)
    }

}
