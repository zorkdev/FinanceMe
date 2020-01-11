import Combine
@testable import FinanceMeKit

public final class MockSessionBusinessLogic: SessionBusinessLogicType {
    @Published public var isLoggedInReturnValue = false
    public var isLoggedIn: AnyPublisher<Bool, Never> { $isLoggedInReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var lastLoginParam: Credentials?
    public var loginReturnValue: Result<Void, Error>?
    public func login(credentials: Credentials) -> AnyPublisher<Void, Error> {
        lastLoginParam = credentials
        let returnValue = loginReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var didCallLogOut = false
    public func logOut() {
        didCallLogOut = true
    }
}
