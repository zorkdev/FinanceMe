public protocol StringRepresentable {

    static var instanceName: String { get }
    var instanceName: String { get }

}

public extension StringRepresentable {

    static var instanceName: String {
        return String(describing: self)
    }

    var instanceName: String {
        return String(describing: type(of: self))
    }

}

extension Array: StringRepresentable {}
extension Dictionary: StringRepresentable {}
extension Optional: StringRepresentable {}

#if os(macOS)
    import Cocoa

    extension NSViewController: StringRepresentable {}

#elseif os(iOS) || os(tvOS)
    import UIKit

    extension UIViewController: StringRepresentable {}
    extension UITableViewCell: StringRepresentable {}
#endif
