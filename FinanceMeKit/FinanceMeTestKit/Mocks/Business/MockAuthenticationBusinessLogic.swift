import Combine
import FinanceMeKit

public class MockAuthenticationBusinessLogic: AuthenticationBusinessLogicType {
    @Published public var isAuthenticatedReturnValue = false
    public var isAuthenticated: AnyPublisher<Bool, Never> { $isAuthenticatedReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var didCallAuthenticate = false
    public func authenticate() {
        didCallAuthenticate = true
    }

    public var didCallWillEnterForeground = false
    public func willEnterForeground() {
        didCallWillEnterForeground = true
    }

    public var didCallDidEnterBackground = false
    public func didEnterBackground() {
        didCallDidEnterBackground = true
    }
}
