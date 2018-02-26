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
extension ViewController: StringRepresentable {}

#if os(iOS) || os(tvOS)
    extension UITableViewCell: StringRepresentable {}
#endif
