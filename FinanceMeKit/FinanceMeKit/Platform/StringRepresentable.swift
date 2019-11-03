protocol StringRepresentable {
    static var instanceName: String { get }
}

extension StringRepresentable {
    static var instanceName: String { String(describing: self) }
}

extension Array: StringRepresentable {}
