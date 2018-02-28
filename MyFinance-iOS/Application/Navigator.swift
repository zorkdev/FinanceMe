enum Scene {

    case auth
    case home
    case addTransaction
    case settings

}

protocol NavigatorType: BaseNavigatorType {

    func createAuthStack(viewModel: AuthViewModelType)
    func moveTo(scene: Scene, viewModel: ViewModelType)
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
        moveTo(scene: .home, viewModel: viewModel)
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

    func moveTo(scene: Scene, viewModel: ViewModelType) {
        let scene = create(scene: scene, viewModel: viewModel)

        if let currentViewController = viewControllers.last {
            currentViewController.present(viewController: scene.viewController)
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
        case .home: return HomeViewController.instantiate()
        case .addTransaction: return AddTransactionViewController.instantiate()
        case .settings: return SettingsViewController.instantiate()
        }
    }

}
