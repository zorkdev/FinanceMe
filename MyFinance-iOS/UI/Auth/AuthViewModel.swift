import LocalAuthentication

protocol LAContextType {
    func createContext() -> LAContextType
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
}

extension LAContext: LAContextType {
    func createContext() -> LAContextType {
        return LAContext()
    }
}

protocol AuthViewModelDelegate: ViewModelDelegate {
    func updateTryAgain(isHidden: Bool)
    func updateLogo(isHidden: Bool)
}

protocol AuthViewModelType: ViewModelType {
    func authenticate()
    func addOcclusion()
    func tryAgainButtonTapped()
}

class AuthViewModel: AuthViewModelType, ServiceClient {
    private enum Constants {
        static let reason = "Please authenticate to unlock this app."
    }

    typealias ServiceProvider = NavigatorProvider & DataServiceProvider & LAContextProvider & SessionServiceProvider
    let serviceProvider: ServiceProvider

    weak var delegate: AuthViewModelDelegate?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    func tryAgainButtonTapped() {
        authenticate()
    }

    @objc
    func authenticate() {
        var error: NSError?

        let context = serviceProvider.laContext.createContext()

        guard serviceProvider.sessionService.hasSession,
            context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            removeOcclusion()
            return
        }

        addOcclusion()

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: Constants.reason) { [weak self] success, _ in
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

    func addOcclusion() {
        guard serviceProvider.sessionService.hasSession else { return }
        serviceProvider.navigator.showAuthWindow()
    }

    private func removeOcclusion() {
        delegate?.updateTryAgain(isHidden: true)
        delegate?.updateLogo(isHidden: false)
        serviceProvider.navigator.hideAuthWindow()
    }

    func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? AuthViewModelDelegate else { return }
        self.delegate = delegate
    }
}
