import Combine
import FinanceMeKit

public class MockAuthenticationService: AuthenticationService {
    public init() {}

    public var authenticateReturnValue: Result<Void, Error>?
    public func authenticate() -> AnyPublisher<Void, Error> {
        let returnValue = authenticateReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var didCallInvalidate = false
    public func invalidate() {
        didCallInvalidate = true
    }
}
