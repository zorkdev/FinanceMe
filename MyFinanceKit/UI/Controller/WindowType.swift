#if os(iOS) || os(tvOS)
public typealias Window = UIWindow
#endif

public protocol WindowType {

    var frame: CGRect { get set }
    var windowLevel: UIWindow.Level { get set }
    var isHidden: Bool { get set }
    var baseViewController: ViewControllerType? { get set }

    func endEditing(_ force: Bool) -> Bool
    func makeKeyAndVisible()
    func createWindow(frame: CGRect) -> WindowType

}

extension Window: WindowType {

    public var baseViewController: ViewControllerType? {
        get {
            return rootViewController as? ViewControllerType
        }
        set {
            rootViewController = newValue as? ViewController
        }
    }

    public func createWindow(frame: CGRect) -> WindowType {
        return Window(frame: frame)
    }

}
