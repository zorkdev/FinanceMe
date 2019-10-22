import Combine
import FinanceMeKit

public class MockTransactionBusinessLogic: TransactionBusinessLogicType {
    @Published public var transactionsReturnValue: [Transaction] = [Transaction.stub]
    public var transactions: AnyPublisher<[Transaction], Never> { $transactionsReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var didCallFetchTransactions = false
    public func fetchTransactions() {
        didCallFetchTransactions = true
    }

    public var didCallGetTransactions = false
    public var getTransactionsReturnValue: Result<Void, Error>?
    public func getTransactions() -> AnyPublisher<Void, Error> {
        didCallGetTransactions = true
        let returnValue = getTransactionsReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var lastCreateParam: Transaction?
    public var createReturnValue: Result<Void, Error>?
    public func create(transaction: Transaction) -> AnyPublisher<Void, Error> {
        lastCreateParam = transaction
        let returnValue = createReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var lastUpdateParam: Transaction?
    public var updateReturnValue: Result<Void, Error>?
    public func update(transaction: Transaction) -> AnyPublisher<Void, Error> {
        lastUpdateParam = transaction
        let returnValue = updateReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var lastDeleteParam: Transaction?
    public var deleteReturnValue: Result<Void, Error>?
    public func delete(transaction: Transaction) -> AnyPublisher<Void, Error> {
        lastDeleteParam = transaction
        let returnValue = deleteReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }

    public var didCallReconcile = false
    public var reconcileReturnValue: Result<Void, Error>?
    public func reconcile() -> AnyPublisher<Void, Error> {
        didCallReconcile = true
        let returnValue = reconcileReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
