public protocol BaseNavigatorType {

    var window: WindowType? { get set }
    var viewControllers: [ViewControllerType] { get set }

    init(window: WindowType)
    func createNavigationStack(viewModel: ViewModelType)
    func dismiss()
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
