import Combine

final class FeedViewModel: ObservableObject {
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    private var cancellables: Set<AnyCancellable> = []

    @Published var sections: [ListSection<Transaction>] = []

    init(loadingState: LoadingState,
         errorViewModel: ErrorViewModel,
         userBusinessLogic: UserBusinessLogicType,
         transactionBusinessLogic: TransactionBusinessLogicType,
         summaryBusinessLogic: SummaryBusinessLogicType) {
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.loadingState = loadingState
        self.errorViewModel = errorViewModel
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
        loadingState.isLoading = true

        row.first
            .flatMap { transactionBusinessLogic.delete(transaction: section.rows[$0]) }?
            .flatMap { self.userBusinessLogic.getUser() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables)
    }
}
