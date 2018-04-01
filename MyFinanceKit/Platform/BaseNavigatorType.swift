public protocol BaseNavigatorType {

    var appState: AppStateType! { get set }
    var window: WindowType? { get set }
    var viewControllers: [ViewControllerType] { get set }

    init(window: WindowType)
    func createNavigationStack()
    @discardableResult func dismiss() -> Promise<Void>
    func popToRoot()
    func inject(viewController: ViewControllerType, viewModel: ViewModelType)

}

public extension BaseNavigatorType {

    public func inject(viewController: ViewControllerType, viewModel: ViewModelType) {
        if let injectableViewController = viewController as? ViewModelInjectable {
            injectableViewController.inject(viewModel: viewModel)
        }

        viewModel.inject(delegate: viewController)
    }

}
