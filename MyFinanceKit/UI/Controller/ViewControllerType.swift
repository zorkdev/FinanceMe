#if os(macOS)
public typealias ViewController = NSViewController
#elseif os(iOS) || os(tvOS)
public typealias ViewController = UIViewController
#elseif os(watchOS)
public typealias ViewController = WKInterfaceController
#endif

public protocol ViewControllerType: ViewModelDelegate {

    var presented: ViewControllerType? { get }

    #if os(iOS)
    var modalTransitionStyle: UIModalTransitionStyle { get set }
    #endif

    func present(viewController: ViewControllerType, animated: Bool)
    func dismiss() -> Promise<Void>

}

public protocol ViewModelInjectable {

    func inject(viewModel: ViewModelType)

}
