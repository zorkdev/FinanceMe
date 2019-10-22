import Combine

public class FeedViewModel: ObservableObject {
    private let businessLogic: TransactionBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var sections: [ListSection<Transaction>] = []

    public init(businessLogic: TransactionBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    private func setupBindings() {
        businessLogic.transactions
            .map { $0.filter { $0.source == .externalInbound || $0.source == .externalOutbound } }
            .map {
                Dictionary(grouping: $0) { Formatters.relativeDateFormatter.string(from: $0.created) }
                .sorted { $0.value[0].created > $1.value[0].created }
                .map { ListSection(title: $0.key, rows: $0.value) }
            }.receive(on: DispatchQueue.main)
            .assign(to: \.sections, on: self)
            .store(in: &cancellables)
    }
}
