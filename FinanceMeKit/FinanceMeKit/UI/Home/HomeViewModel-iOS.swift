import Combine

public class HomeViewModel: ObservableObject {
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let authenticationBusinessLogic: AuthenticationBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var isAuthenticated: Bool = false

    public init(transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType,
                authenticationBusinessLogic: AuthenticationBusinessLogicType) {
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.authenticationBusinessLogic = authenticationBusinessLogic
        setupBindings()
    }

    func onAppear() {
        transactionBusinessLogic.fetchTransactions()
        summaryBusinessLogic.fetchSummary()
    }

    private func setupBindings() {
        authenticationBusinessLogic.isAuthenticated
            .receive(on: DispatchQueue.main)
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
    }
}
