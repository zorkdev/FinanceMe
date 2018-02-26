extension ViewController {

    public static let storyboardId = "Main"

}

public protocol Instantiatable {

    static var storyboardId: String { get }
    static var bundle: Bundle { get }

}

extension Instantiatable where Self: ViewController {

    public static var bundle: Bundle {
        return Bundle(for: Self.self)
    }

    public static func instantiate() -> Self {
        #if os(iOS) || os(tvOS)
        let viewController = (UIStoryboard(name: storyboardId, bundle: bundle)
            .instantiateViewController(withIdentifier: Self.instanceName) as? Self)!

        #elseif os(watchOS)
        let viewController = Self()

        #elseif os(macOS)
        let viewController = (NSStoryboard(name: NSStoryboard.Name(storyboardId), bundle: bundle)
            .instantiateController(withIdentifier:
                NSStoryboard.SceneIdentifier(rawValue: Self.instanceName)) as? Self)!
        #endif

        return viewController
    }

}

extension ViewController: Instantiatable {}
