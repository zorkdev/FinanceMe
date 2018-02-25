import LocalAuthentication

protocol LAContextType {

    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)

}

extension LAContext: LAContextType {}

protocol AuthViewModelDelegate: class {

    func updateTryAgain(isHidden: Bool)
    func updateLogo(isHidden: Bool)

}

protocol AuthViewModelType: ViewModelType {

    var delegate: AuthViewModelDelegate? { get set }

    func authenticate()
    func addOcclusion()
    func tryAgainButtonTapped()

}

class AuthViewModel: AuthViewModelType {

    private struct Constants {
        static let reason = "Please authenticate to unlock this app"
    }

    private var appWindow: UIWindow?
    private var window: UIWindow?
    private weak var viewController: UIViewController?
    private let context: LAContextType

    weak var delegate: AuthViewModelDelegate?

    init(delegate: AuthViewModelDelegate,
         window: UIWindow?,
         viewController: UIViewController,
         context: LAContextType) {
        self.delegate = delegate
        appWindow = window
        self.viewController = viewController
        self.context = context
    }

    func tryAgainButtonTapped() {
        authenticate()
    }

    @objc func authenticate() {
        addOcclusion()

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

        window = UIWindow(frame: frame)
        window?.windowLevel = UIWindowLevelNormal + 2
        window?.rootViewController = viewController
        if isTesting == false { window?.makeKeyAndVisible() }
    }

    private func removeOcclusion() {
        delegate?.updateTryAgain(isHidden: true)
        delegate?.updateLogo(isHidden: false)
        window?.isHidden = true
    }

}
