#if os(macOS)
public typealias ViewController = NSViewController
#elseif os(iOS) || os(tvOS)
public typealias ViewController = UIViewController
#elseif os(watchOS)
public typealias ViewController = WKInterfaceController
#endif

public protocol ViewControllerType: ViewModelDelegate {

    func present(viewController: ViewControllerType)
    func dismiss()

}

public protocol ViewModelInjectable {

    func inject(viewModel: ViewModelType)

}
