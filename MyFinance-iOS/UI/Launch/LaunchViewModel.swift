protocol LaunchViewModelType: ViewModelType {

    func viewDidAppear()

}

class LaunchViewModel: ServiceClient {

    typealias ServiceProvider = NavigatorProvider
        & DataServiceProvider
        & SessionServiceProvider
        & PushNotificationServiceProvider
    let serviceProvider: ServiceProvider

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

}

// MARK: - Interface

extension LaunchViewModel: LaunchViewModelType {

    func viewDidAppear() {
        if hasSession {
            moveToHome()
            serviceProvider.pushNotificationService.registerForNotifications()
        } else {
            moveToLogin()
        }
    }

    func inject(delegate: ViewModelDelegate) {}

}

// MARK: - Private methods

extension LaunchViewModel {

    private var hasSession: Bool {
        return serviceProvider.sessionService.hasSession
    }

    private func moveToHome() {
        self.serviceProvider.navigator.moveTo(scene: .home, viewModel: nil)
    }

    private func moveToLogin() {
        self.serviceProvider.navigator.moveTo(scene: .login, viewModel: nil)
    }

}
