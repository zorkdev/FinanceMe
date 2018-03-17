enum Scene {

    case auth
    case login
    case home
    case addTransaction
    case settings

}

protocol NavigatorType: BaseNavigatorType {

    func createAuthStack(viewModel: AuthViewModelType)
    func moveTo(scene: Scene, viewModel: ViewModelType, animated: Bool)
    func showAuthWindow()
    func hideAuthWindow()

}

class Navigator: NavigatorType {

    private var authWindow: WindowType?

    var window: WindowType?
    var viewControllers = [ViewControllerType]()

    required init(window: WindowType) {
        self.window = window
    }

    func createNavigationStack(viewModel: ViewModelType) {
        moveTo(scene: .login, viewModel: viewModel, animated: false)
        window?.makeKeyAndVisible()
    }

    func createAuthStack(viewModel: AuthViewModelType) {
        let scene = create(scene: .auth, viewModel: viewModel)

        guard let frame = window?.frame else { fatalError() }
        authWindow = window?.createWindow(frame: frame)
        authWindow?.windowLevel = UIWindowLevelStatusBar - 1
        authWindow?.baseViewController = scene.viewController
        authWindow?.makeKeyAndVisible()
    }

    func moveTo(scene: Scene, viewModel: ViewModelType, animated: Bool) {
        let scene = create(scene: scene, viewModel: viewModel)

        if let currentViewController = viewControllers.last {
            currentViewController.present(viewController: scene.viewController, animated: animated)
        } else {
            window?.baseViewController = scene.viewController
        }

        viewControllers.append(scene.viewController)
    }

    @discardableResult func dismiss() -> Promise<Void> {
        guard let lastViewController = viewControllers.last else { return Promise(error: AppError.unknownError) }
        return lastViewController.dismiss().done {
            self.viewControllers.removeLast()
        }
    }

    func popToRoot() {
        for (index, viewController) in viewControllers.reversed().enumerated() where index < viewControllers.count - 1 {
            _ = viewController.dismiss()
        }
        viewControllers.removeLast(viewControllers.count - 1)
    }

    func showAuthWindow() {
        _ = window?.endEditing(true)
        authWindow?.isHidden = false
    }

    func hideAuthWindow() {
        authWindow?.isHidden = true
    }

    private func create(scene: Scene,
                        viewModel: ViewModelType) -> (viewController: ViewControllerType, viewModel: ViewModelType) {
        let viewController = createViewController(scene: scene)
        inject(viewController: viewController, viewModel: viewModel)

        return (viewController: viewController, viewModel: viewModel)
    }

    private func createViewController(scene: Scene) -> ViewControllerType {
        switch scene {
        case .auth: return AuthViewController.instantiate()
        case .login: return LoginViewController.instantiate()
        case .home: return HomeViewController.instantiate()
        case .addTransaction: return AddTransactionViewController.instantiate()
        case .settings: return SettingsViewController.instantiate()
        }
    }

}
