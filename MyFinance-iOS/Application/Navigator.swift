enum Scene {

    case launch
    case auth
    case login
    case home
    case addTransaction
    case settings

}

struct SceneModel {

    let viewController: ViewControllerType
    let viewModel: ViewModelType

}

protocol NavigatorType: BaseNavigatorType {

    func createAuthStack(viewModel: AuthViewModelType)
    func moveTo(scene: Scene, viewModel: ViewModelType?)
    func showAuthWindow()
    func hideAuthWindow()

}

class Navigator: NavigatorType {

    private var authWindow: WindowType?

    weak var appState: AppStateType!
    var window: WindowType?
    var viewControllers = [ViewControllerType]()

    required init(window: WindowType) {
        self.window = window
    }

    func createNavigationStack() {
        moveTo(scene: .launch, viewModel: nil)
        window?.makeKeyAndVisible()
    }

    func createAuthStack(viewModel: AuthViewModelType) {
        let scene = create(scene: .auth, viewModel: viewModel)

        guard let frame = window?.frame else { fatalError() }
        authWindow = window?.createWindow(frame: frame)
        authWindow?.windowLevel = UIWindowLevelStatusBar - 1
        authWindow?.baseViewController = scene.viewController
        authWindow?.makeKeyAndVisible()
        hideAuthWindow()
    }

    func moveTo(scene: Scene, viewModel: ViewModelType?) {
        let scene = create(scene: scene, viewModel: viewModel)

        if let currentViewController = viewControllers.last {
            currentViewController.present(viewController: scene.viewController, animated: true)
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

    private func create(scene: Scene, viewModel: ViewModelType?) -> SceneModel {
        let viewModel = viewModel ?? createViewModel(scene: scene)
        let viewController = createViewController(scene: scene)
        viewController.modalTransitionStyle = createTransitionStyle(scene: scene)
        inject(viewController: viewController, viewModel: viewModel)

        return SceneModel(viewController: viewController,
                          viewModel: viewModel)
    }

    private func createViewModel(scene: Scene) -> ViewModelType {
        switch scene {
        case .launch: return LaunchViewModel(serviceProvider: appState as! LaunchViewModel.ServiceProvider)
        case .auth: return AuthViewModel(serviceProvider: appState as! AuthViewModel.ServiceProvider)
        case .login: return LoginViewModel(serviceProvider: appState as! LoginViewModel.ServiceProvider)
        case .home: return HomeViewModel(serviceProvider: appState as! HomeViewModel.ServiceProvider)
        case .addTransaction:
            return AddTransactionViewModel(serviceProvider: appState as! AddTransactionViewModel.ServiceProvider,
                                           dataDelegate: nil)
        case .settings:
            return SettingsViewModel(serviceProvider: appState as! SettingsViewModel.ServiceProvider,
                                     dataDelegate: nil)
        }
    }

    private func createViewController(scene: Scene) -> ViewControllerType {
        switch scene {
        case .launch: return LaunchViewController.instantiate()
        case .auth: return AuthViewController.instantiate()
        case .login: return LoginViewController.instantiate()
        case .home: return HomeViewController.instantiate()
        case .addTransaction: return AddTransactionViewController.instantiate()
        case .settings: return SettingsViewController.instantiate()
        }
    }

    private func createTransitionStyle(scene: Scene) -> UIModalTransitionStyle {
        switch scene {
        case .launch, .login, .home: return .crossDissolve
        case .auth, .addTransaction, .settings: return .coverVertical
        }
    }

}
