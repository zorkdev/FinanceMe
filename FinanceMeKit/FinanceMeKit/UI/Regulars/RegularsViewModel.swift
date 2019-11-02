import Combine

public class RegularsViewModel: ObservableObject {
    public struct MonthlyBalance {
        public let allowance: Decimal
        public let outgoings: Decimal
    }

    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let loadingState: LoadingState
    private var cancellables: Set<AnyCancellable> = []

    @Published public var monthlyBalance = MonthlyBalance(allowance: 0, outgoings: 0)
    @Published public var incomingSection = ListSection<Transaction>(title: "", rows: [])
    @Published public var outgoingSection = ListSection<Transaction>(title: "", rows: [])

    public init(loadingState: LoadingState,
                userBusinessLogic: UserBusinessLogicType,
                transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.loadingState = loadingState
        setupBindings()
    }

    private func setupBindings() {
        setupMonthlyBalance()
        setupIncomingSection()
        setupOutgoingSection()
    }

    private func setupMonthlyBalance() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularInbound || $0.source == .externalRegularOutbound } }
            .map {
                let allowance = $0
                    .map { $0.amount }
                    .reduce(0, +)
                let outgoings = $0
                    .filter { $0.source == .externalRegularOutbound }
                    .map { $0.amount }
                    .reduce(0, +)
                return MonthlyBalance(allowance: allowance, outgoings: outgoings)
            }.receive(on: DispatchQueue.main)
            .assign(to: \.monthlyBalance, on: self)
            .store(in: &cancellables)
    }

    private func setupIncomingSection() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularInbound } }
            .map { $0.sorted { $0.amount > $1.amount } }
            .map { ListSection(title: "Incoming", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.incomingSection, on: self)
            .store(in: &cancellables)
    }

    private func setupOutgoingSection() {
        transactionBusinessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularOutbound } }
            .map { $0.sorted { $0.amount < $1.amount } }
            .map { ListSection(title: "Outgoing", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.outgoingSection, on: self)
            .store(in: &cancellables)
    }

    func onDelete(section: ListSection<Transaction>, row: IndexSet) {
        loadingState.isLoading = true

        row.first
            .flatMap { transactionBusinessLogic.delete(transaction: section.rows[$0]) }?
            .flatMap { self.userBusinessLogic.getUser() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.loadingState.isLoading = false }, receiveValue: {})
            .store(in: &cancellables)
    }
}
