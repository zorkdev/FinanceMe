protocol Instantiatable {

    static var storyboardId: String { get }
    static var bundle: Bundle { get }

}

extension Instantiatable where Self: UIViewController {

    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }

    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardId, bundle: bundle)
            .instantiateViewController(withIdentifier: Self.instanceName) as? Self else {
                fatalError()
        }
        return viewController
    }

}

extension UIViewController: Instantiatable {

    static let storyboardId = "Main"

}
