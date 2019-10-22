import Combine

public protocol TransactionBusinessLogicType {
    var transactions: AnyPublisher<[Transaction], Never> { get }
    func fetchTransactions()
    func getTransactions() -> AnyPublisher<Void, Error>
    func create(transaction: Transaction) -> AnyPublisher<Void, Error>
    func update(transaction: Transaction) -> AnyPublisher<Void, Error>
    func delete(transaction: Transaction) -> AnyPublisher<Void, Error>
    func reconcile() -> AnyPublisher<Void, Error>
}

class TransactionBusinessLogic: TransactionBusinessLogicType {
    private let networkService: NetworkService
    private let dataService: DataService
    private var cancellables: Set<AnyCancellable> = []

    @Published private var internalTransactions: [Transaction]

    var transactions: AnyPublisher<[Transaction], Never> { $internalTransactions.eraseToAnyPublisher() }

    init(networkService: NetworkService, dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
        self.internalTransactions = Self.loadTransactions(dataService: dataService)
    }

    func fetchTransactions() {
        getTransactions()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
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

    func create(transaction: Transaction) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.transactions,
                     method: .post,
                     body: transaction)
            .tryMap { (transaction: Transaction) in
                var transactions = Self.loadTransactions(dataService: self.dataService)
                transactions.append(transaction)
                if case .failure(let error) = transactions.save(dataService: self.dataService) { throw error }
                self.internalTransactions = transactions
            }.eraseToAnyPublisher()
    }

    func update(transaction: Transaction) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.transaction(transaction.id),
                     method: .put,
                     body: transaction)
            .tryMap { (transaction: Transaction) in
                var transactions = Self.loadTransactions(dataService: self.dataService)
                transactions.removeAll { $0.id == transaction.id }
                transactions.append(transaction)
                if case .failure(let error) = transactions.save(dataService: self.dataService) { throw error }
                self.internalTransactions = transactions
            }.eraseToAnyPublisher()
    }

    func delete(transaction: Transaction) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.transaction(transaction.id),
                     method: .delete,
                     body: nil)
            .tryMap { _ in
                var transactions = Self.loadTransactions(dataService: self.dataService)
                transactions.removeAll { $0.id == transaction.id }
                if case .failure(let error) = transactions.save(dataService: self.dataService) { throw error }
                self.internalTransactions = transactions
            }.eraseToAnyPublisher()
    }

    func reconcile() -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.reconcile,
                     method: .post,
                     body: nil)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    private static func loadTransactions(dataService: DataService) -> [Transaction] {
        [Transaction].load(dataService: dataService) ?? []
    }
}

#if DEBUG
extension Stub {
    class StubTransactionBusinessLogic: TransactionBusinessLogicType {
        let transactions: AnyPublisher<[Transaction], Never> = Just([]).eraseToAnyPublisher()
        func fetchTransactions() {}
        func getTransactions() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        func create(transaction: Transaction) -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        func update(transaction: Transaction) -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        func delete(transaction: Transaction) -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        func reconcile() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
    }
}
#endif
