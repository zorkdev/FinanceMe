public struct NoReturnValueProviderError: Error {
    public let function: String

    public init(function: String) {
        self.function = function
    }
}

public struct TestError: Error {}
