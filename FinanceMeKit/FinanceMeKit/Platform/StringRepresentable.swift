public protocol StringRepresentable {
    static var instanceName: String { get }
}

public extension StringRepresentable {
    static var instanceName: String { String(describing: self) }
}

extension Array: StringRepresentable {}

#if os(macOS)
import AppKit

extension NSViewController: StringRepresentable {}
#endif
