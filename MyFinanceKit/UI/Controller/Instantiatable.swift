public extension ViewController {
    static let storyboardId = "Main"
}

public protocol Instantiatable {
    // swiftlint:disable:next unused_declaration
    static var storyboardId: String { get }
    static var bundle: Bundle { get }
}

public extension Instantiatable where Self: ViewController {
    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }

    // swiftlint:disable:next unused_declaration
    static func instantiate() -> Self {
        #if os(iOS) || os(tvOS)
        let viewController = (UIStoryboard(name: storyboardId, bundle: bundle)
            .instantiateViewController(withIdentifier: Self.instanceName) as? Self)!

        #elseif os(watchOS)
        let viewController = Self()

        #elseif os(macOS)
        let viewController = (NSStoryboard(name: storyboardId, bundle: bundle)
            .instantiateController(withIdentifier: Self.instanceName) as? Self)!
        #endif

        return viewController
    }
}

extension ViewController: Instantiatable {}
