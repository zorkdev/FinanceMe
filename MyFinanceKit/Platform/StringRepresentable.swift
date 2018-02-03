public protocol StringRepresentable where Self: CustomStringConvertible {

    static var string: String { get }

}

public extension StringRepresentable {

    static var string: String {
        return String(describing: self)
    }

}
