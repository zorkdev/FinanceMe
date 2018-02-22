public protocol FatalErrorable {

    func fatalError(message: String)

}

public struct SwiftFatalError: FatalErrorable {

    public init() {}

    public func fatalError(message: String) {
        Swift.fatalError(message)
    }

}
