import Combine
import FinanceMeKit

public class MockBalanceBusinessLogic: BalanceBusinessLogicType {
    public init() {}

    public var getBalanceReturnValue: Result<Balance, Error>?
    public func getBalance() -> AnyPublisher<Balance, Error> {
        let returnValue = getBalanceReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
