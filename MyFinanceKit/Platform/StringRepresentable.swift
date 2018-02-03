public protocol StringRepresentable where Self: CustomStringConvertible {

    static var string: String { get }

}

public extension StringRepresentable {

    static var string: String {
        return String(describing: self)
    }

}

#if os(macOS)
    import Cocoa

    extension NSViewController: StringRepresentable {}

#elseif os(iOS)
    import UIKit

    extension UIViewController: StringRepresentable {}
    extension UITableViewCell: StringRepresentable {}
#endif
