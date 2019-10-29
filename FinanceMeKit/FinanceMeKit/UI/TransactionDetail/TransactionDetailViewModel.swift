import Combine

public class TransactionDetailViewModel: ObservableObject {
    private static let formatter = Formatters.currency

    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let transaction: Transaction?
    private var cancellables: Set<AnyCancellable> = []
    private let id = UUID()

    @Published public var amount = ""
    @Published public var narrative: String
    @Published public var category: Transaction.Source
    @Published public var date: Date
    @Published public var isDisabled = true
    @Published public var shouldDismiss = false

    private var amountValue: Decimal? { Self.formatter.decimal(from: amount) }

    private var newTransaction: Transaction? {
        guard let amountValue = amountValue else { return nil }

        let direction: Transaction.Direction
        switch category {
        case .externalOutbound, .externalRegularOutbound: direction = .outbound
        case .externalInbound, .externalRegularInbound: direction = .inbound
        }

        let amount = direction == .outbound ? -amountValue : amountValue

        return Transaction(id: transaction?.id ?? id,
                           amount: amount,
                           direction: direction,
                           created: date,
                           narrative: narrative,
                           source: category)
    }

    public init(transaction: Transaction?,
                userBusinessLogic: UserBusinessLogicType,
                transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.transaction = transaction

        if let amount = transaction?.amount {
            self.amount = Self.formatter.string(from: abs(amount))
        }

        self.narrative = transaction?.narrative ?? ""
        self.category = transaction?.source ?? .externalOutbound
        self.date = transaction?.created ?? Date()
        setupBindings()
    }

    func onAmountEditingChanged(isEditing: Bool) {
        if let amountValue = amountValue {
            amount = Self.formatter.string(from: amountValue)
        } else {
            amount = ""
        }
    }

    func onSave() {
        guard let newTransaction = newTransaction else { return }

        let publisher: AnyPublisher<Void, Error>
        if transaction != nil {
            publisher = transactionBusinessLogic.update(transaction: newTransaction)
        } else {
            publisher = transactionBusinessLogic.create(transaction: newTransaction)
        }

        publisher
            .flatMap { self.userBusinessLogic.getUser() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {
                self.shouldDismiss = true
            })
            .store(in: &cancellables)
    }

    private func setupBindings() {
        Publishers.CombineLatest4($amount, $narrative, $category, $date)
            .receive(on: DispatchQueue.main)
            .map { _ in
                guard let newTransaction = self.newTransaction else { return true }

                if let transaction = self.transaction {
                    return newTransaction == transaction
                }

                return false
            }.assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }
}
