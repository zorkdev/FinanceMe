import LocalAuthentication

protocol LAContextType {

    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)

}

extension LAContext: LAContextType {}

protocol AuthViewModelDelegate: ViewModelDelegate {

    func updateTryAgain(isHidden: Bool)
    func updateLogo(isHidden: Bool)

}

protocol AuthViewModelType: ViewModelType {

    func authenticate()
    func addOcclusion()
    func tryAgainButtonTapped()

}

class AuthViewModel: AuthViewModelType {

    private struct Constants {
        static let reason = "Please authenticate to unlock this app"
    }

    typealias ServiceProvider = NavigatorProvider & DataServiceProvider & LAContextProvider
    let serviceProvider: ServiceProvider

    weak var delegate: AuthViewModelDelegate?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    func tryAgainButtonTapped() {
        authenticate()
    }

    @objc func authenticate() {
        guard Session.load(dataService: serviceProvider.dataService) != nil else {
            removeOcclusion()
            return
        }

        addOcclusion()

        var error: NSError?

        if serviceProvider.laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            serviceProvider.laContext
                .evaluatePolicy(.deviceOwnerAuthentication,
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
        guard Session.load(dataService: serviceProvider.dataService) != nil else { return }
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
