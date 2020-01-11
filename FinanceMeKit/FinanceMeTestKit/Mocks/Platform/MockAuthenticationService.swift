import Combine
@testable import FinanceMeKit

public final class MockAuthenticationService: AuthenticationService {
    public init() {}

    public var lastAuthenticateParam: String?
    public var authenticateReturnValue: Result<Void, Error>?
    public func authenticate(reason: String) -> AnyPublisher<Void, Error> {
        lastAuthenticateParam = reason
        let returnValue = authenticateReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
