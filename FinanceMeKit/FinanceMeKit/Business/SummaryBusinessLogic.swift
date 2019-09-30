import Combine

public protocol SummaryBusinessLogicType {
    var summary: AnyPublisher<Summary?, Never> { get }
    func getSummary() -> AnyPublisher<Void, Error>
}

class SummaryBusinessLogic: SummaryBusinessLogicType {
    private let networkService: NetworkService
    private let dataService: DataService

    @Published private var internalSummary: Summary?

    var summary: AnyPublisher<Summary?, Never> { $internalSummary.eraseToAnyPublisher() }

    init(networkService: NetworkService, dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
        self.internalSummary = Summary.load(dataService: dataService)
    }

    func getSummary() -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.summary,
                     method: .get,
                     body: nil)
            .tryMap { (summary: Summary) in
                if case .failure(let error) = summary.save(dataService: self.dataService) { throw error }
                self.internalSummary = summary
            }.eraseToAnyPublisher()
    }
}

#if DEBUG
extension Stub {
    class StubSummaryBusinessLogic: SummaryBusinessLogicType {
        let summary: AnyPublisher<Summary?, Never> = Just(Summary(
            currentMonthSummary: CurrentMonthSummary(allowance: 90.30, forecast: -65.50, spending: 250.71),
            endOfMonthSummaries: [
                EndOfMonthSummary(balance: 41.90,
                                  created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!)
            ])).eraseToAnyPublisher()
        func getSummary() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
    }
}
#endif
