import Combine
@testable import FinanceMeKit

public final class MockUserBusinessLogic: UserBusinessLogicType {
    @Published public var userReturnValue: User?
    public var user: AnyPublisher<User?, Never> { $userReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var didCallFetchUser = false
    public func fetchUser() {
        didCallFetchUser = true
    }

    public var didCallGetUser = false
    public var getUserReturnValue: Result<Void, Error>?
    public func getUser() -> AnyPublisher<Void, Error> {
        didCallGetUser = true
        let returnValue = getUserReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var lastUpdateParam: User?
    public var updateReturnValue: Result<Void, Error>?
    public func update(user: User) -> AnyPublisher<Void, Error> {
        lastUpdateParam = user
        let returnValue = updateReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
