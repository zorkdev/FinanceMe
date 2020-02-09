import Combine

final class RegularsViewModel: ObservableObject {
    struct MonthlyBalance {
        let allowance: Double
        let outgoings: Double
    }

    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    private var cancellables: Set<AnyCancellable> = []

    @Published var monthlyBalance = MonthlyBalance(allowance: .zero, outgoings: .zero)
    @Published var savingsSection = ListSection<Transaction>(title: "", rows: [])
    @Published var incomingSection = ListSection<Transaction>(title: "", rows: [])
    @Published var outgoingSection = ListSection<Transaction>(title: "", rows: [])

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

    func onDelete(section: ListSection<Transaction>, row: IndexSet) {
        loadingState.isLoading = true

        row.first
            .flatMap { transactionBusinessLogic.delete(transaction: section.rows[$0]) }?
            .flatMap { self.userBusinessLogic.getUser() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables)
    }
}

private extension RegularsViewModel {
    func setupBindings() {
        setupMonthlyBalance()
        setupSavingsSection()
        setupIncomingSection()
        setupOutgoingSection()
    }

    func setupMonthlyBalance() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularInbound || $0.source == .externalRegularOutbound } }
            .map {
                let allowance = $0
                    .map { $0.amount }
                    .reduce(.zero, +)
                let outgoings = $0
                    .filter { $0.source == .externalRegularOutbound }
                    .map { $0.amount }
                    .reduce(.zero, +)
                return MonthlyBalance(allowance: allowance, outgoings: outgoings)
            }.receive(on: DispatchQueue.main)
            .assign(to: \.monthlyBalance, on: self)
            .store(in: &cancellables)
    }

    func setupSavingsSection() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalSavings } }
            .map { $0.sorted { $0.amount < $1.amount } }
            .map { ListSection(title: "Savings", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.savingsSection, on: self)
            .store(in: &cancellables)
    }

    func setupIncomingSection() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularInbound } }
            .map { $0.sorted { $0.amount > $1.amount } }
            .map { ListSection(title: "Incoming", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.incomingSection, on: self)
            .store(in: &cancellables)
    }

    func setupOutgoingSection() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularOutbound } }
            .map { $0.sorted { $0.amount < $1.amount } }
            .map { ListSection(title: "Outgoing", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.outgoingSection, on: self)
            .store(in: &cancellables)
    }
}
