import Combine
import FinanceMeKit

public class MockUserBusinessLogic: UserBusinessLogicType {
    public init() {}

    public var lastLoginParam: Credentials?
    public var loginReturnValue: Result<Void, Error>?
    public func login(credentials: Credentials) -> AnyPublisher<Void, Error> {
        lastLoginParam = credentials
        let returnValue = loginReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var getUserReturnValue: Result<User, Error>?
    public func getUser() -> AnyPublisher<User, Error> {
        let returnValue = getUserReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var lastUpdateParam: User?
    public var updateReturnValue: Result<User, Error>?
    public func update(user: User) -> AnyPublisher<User, Error> {
        lastUpdateParam = user
        let returnValue = updateReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
