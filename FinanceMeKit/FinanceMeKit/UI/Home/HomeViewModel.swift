import Combine

final class HomeViewModel: ObservableObject {
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    private var cancellables: Set<AnyCancellable> = []

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
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables)
    }
}
