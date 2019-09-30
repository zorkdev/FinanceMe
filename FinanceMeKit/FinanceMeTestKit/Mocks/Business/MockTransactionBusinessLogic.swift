import Combine
import FinanceMeKit

public class MockTransactionBusinessLogic: TransactionBusinessLogicType {
    @Published public var transactionsReturnValue = [Transaction]()
    public var transactions: AnyPublisher<[Transaction], Never> { $transactionsReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var didCallGetTransactions = false
    public var getTransactionsReturnValue: Result<Void, Error>?
    public func getTransactions() -> AnyPublisher<Void, Error> {
        didCallGetTransactions = true
        let returnValue = getTransactionsReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
