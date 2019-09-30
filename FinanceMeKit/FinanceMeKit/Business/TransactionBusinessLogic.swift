import Combine

public protocol TransactionBusinessLogicType {
    var transactions: AnyPublisher<[Transaction], Never> { get }
    func getTransactions() -> AnyPublisher<Void, Error>
}

class TransactionBusinessLogic: TransactionBusinessLogicType {
    private let networkService: NetworkService
    private let dataService: DataService

    @Published private var internalTransactions: [Transaction]

    var transactions: AnyPublisher<[Transaction], Never> { $internalTransactions.eraseToAnyPublisher() }

    init(networkService: NetworkService, dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
        self.internalTransactions = [Transaction].load(dataService: dataService) ?? []
    }

    func getTransactions() -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.transactions,
                     method: .get,
                     body: nil)
            .tryMap { (transactions: [Transaction]) in
                if case .failure(let error) = transactions.save(dataService: self.dataService) { throw error }
                self.internalTransactions = transactions
            }.eraseToAnyPublisher()
    }
}

#if DEBUG
extension Stub {
    class StubTransactionBusinessLogic: TransactionBusinessLogicType {
        let transactions: AnyPublisher<[Transaction], Never> = Just([]).eraseToAnyPublisher()
        func getTransactions() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
    }
}
#endif
