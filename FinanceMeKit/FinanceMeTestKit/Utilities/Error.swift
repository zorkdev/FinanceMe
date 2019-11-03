import Foundation

public struct NoReturnValueProviderError: Error {
    public let function: String

    public init(function: String) {
        self.function = function
    }
}

public struct TestError: Error, LocalizedError {
    public let errorDescription: String? = "Test Error"

    public init() {}
}
