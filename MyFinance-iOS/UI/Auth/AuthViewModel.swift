import LocalAuthentication

protocol AuthViewModelDelegate: class {

    func updateTryAgain(isHidden: Bool)
    func updateLogo(isHidden: Bool)

}

protocol AuthViewModelType {

    func tryAgainButtonTapped()

}

class AuthViewModel: AuthViewModelType {

    private struct Constants {
        static let reason = "Please authenticate to unlock this app"
    }

    private var appWindow: UIWindow?
    private var window: UIWindow?

    private weak var delegate: AuthViewModelDelegate?

    init(window: UIWindow?) {
        appWindow = window
    }

    func tryAgainButtonTapped() {
        authenticate()
    }

    @objc func authenticate() {
        addOcclusion()

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: Constants.reason) { [weak self] success, _ in
                DispatchQueue.main.async {
                    if success {
                        self?.removeOcclusion()
                    } else {
                        self?.delegate?.updateLogo(isHidden: true)
                        self?.delegate?.updateTryAgain(isHidden: false)
                    }
                }
            }
        }
    }

    func addOcclusion() {
        appWindow?.endEditing(true)

        guard window == nil else {
            window?.isHidden = false
            return
        }

        guard let frame = appWindow?.frame else { fatalError() }

        let authViewController = AuthViewController.instantiate()
        authViewController.viewModel = self
        delegate = authViewController

        window = UIWindow(frame: frame)
        window?.windowLevel = UIWindowLevelNormal + 2
        window?.rootViewController = authViewController
        window?.makeKeyAndVisible()
    }

    private func removeOcclusion() {
        delegate?.updateTryAgain(isHidden: true)
        delegate?.updateLogo(isHidden: false)
        window?.isHidden = true
    }

}
