import Combine

public class FeedViewModel: ObservableObject {
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var sections: [ListSection<Transaction>] = []

    public init(userBusinessLogic: UserBusinessLogicType,
                transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        setupBindings()
    }

    private func setupBindings() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalInbound || $0.source == .externalOutbound } }
            .map {
                Dictionary(grouping: $0) { Formatters.relativeDateFormatter.string(from: $0.created) }
                .sorted { $0.value[0].created > $1.value[0].created }
                .map { ListSection(title: $0.key, rows: $0.value) }
            }.receive(on: DispatchQueue.main)
            .assign(to: \.sections, on: self)
            .store(in: &cancellables)
    }

    func onDelete(section: ListSection<Transaction>, row: IndexSet) {
        row.first
            .flatMap { transactionBusinessLogic.delete(transaction: section.rows[$0]) }?
            .flatMap { self.userBusinessLogic.getUser() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }
}
