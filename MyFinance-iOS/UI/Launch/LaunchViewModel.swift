protocol LaunchViewModelType: ViewModelType {

    func viewDidAppear()

}

class LaunchViewModel {

    typealias ServiceProvider = NavigatorProvider & DataServiceProvider
    let serviceProvider: ServiceProvider

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

}

// MARK: - Interface

extension LaunchViewModel: LaunchViewModelType {

    func viewDidAppear() {
        hasSession ? moveToHome() : moveToLogin()
    }

    func inject(delegate: ViewModelDelegate) {}

}

// MARK: - Private methods

extension LaunchViewModel {

    private var hasSession: Bool {
        return Session.load(dataService: serviceProvider.dataService) != nil
    }

    private func moveToHome() {
        self.serviceProvider.navigator.moveTo(scene: .home, viewModel: nil)
    }

    private func moveToLogin() {
        self.serviceProvider.navigator.moveTo(scene: .login, viewModel: nil)
    }

}
