public protocol BaseNavigatorType {
    // swiftlint:disable:next unused_declaration
    var window: WindowType? { get set }
    // swiftlint:disable:next unused_declaration
    var viewControllers: [ViewControllerType] { get set }

    init(window: WindowType)

    @discardableResult
    func dismiss() -> Promise<Void>

    @discardableResult
    func popToRoot() -> Promise<Void>

    func inject(viewController: ViewControllerType, viewModel: ViewModelType)
}

public extension BaseNavigatorType {
    func inject(viewController: ViewControllerType, viewModel: ViewModelType) {
        if let injectableViewController = viewController as? ViewModelInjectable {
            injectableViewController.inject(viewModel: viewModel)
        }

        viewModel.inject(delegate: viewController)
    }
}
