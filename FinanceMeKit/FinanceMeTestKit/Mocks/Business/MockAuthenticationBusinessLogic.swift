import Combine
@testable import FinanceMeKit

public final class MockAuthenticationBusinessLogic: AuthenticationBusinessLogicType {
    @Published public var isAuthenticatedReturnValue = false
    public var isAuthenticated: AnyPublisher<Bool, Never> { $isAuthenticatedReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var didCallAuthenticate = false
    public func authenticate() {
        didCallAuthenticate = true
    }
}
