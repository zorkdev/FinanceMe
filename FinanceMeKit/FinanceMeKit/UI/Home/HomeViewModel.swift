import Combine

public class HomeViewModel: ObservableObject {
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let loadingState: LoadingState
    private var cancellables: Set<AnyCancellable> = []

    public init(loadingState: LoadingState,
                userBusinessLogic: UserBusinessLogicType,
                transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.loadingState = loadingState
    }

    func onAppear() {
        transactionBusinessLogic.fetchTransactions()
        summaryBusinessLogic.fetchSummary()
    }

    func onRefresh() {
        loadingState.isLoading = true

        userBusinessLogic.getUser()
            .flatMap { self.transactionBusinessLogic.getTransactions() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.loadingState.isLoading = false }, receiveValue: {})
            .store(in: &cancellables)
    }
}
