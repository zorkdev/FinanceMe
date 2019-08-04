public protocol StringRepresentable {
    static var instanceName: String { get }
}

public extension StringRepresentable {
    static var instanceName: String {
        return String(describing: self)
    }
}

extension Array: StringRepresentable {}
