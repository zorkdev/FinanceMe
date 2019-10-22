import Combine

public class RegularsViewModel: ObservableObject {
    public struct MonthlyAllowance {
        public let title = "Monthly Allowance"
        public let amount: Decimal
    }

    private let businessLogic: TransactionBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var monthlyAllowance = MonthlyAllowance(amount: 0)
    @Published public var incomingSection = ListSection<Transaction>(title: "", rows: [])
    @Published public var outgoingSection = ListSection<Transaction>(title: "", rows: [])

    public init(businessLogic: TransactionBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    private func setupBindings() {
        setupMonthlyAllowance()
        setupIncomingSection()
        setupOutgoingSection()
    }

    private func setupMonthlyAllowance() {
        businessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularInbound || $0.source == .externalRegularOutbound } }
            .map {
                let amount = $0.map { $0.amount }.reduce(0, +)
                return MonthlyAllowance(amount: amount)
            }.receive(on: DispatchQueue.main)
            .assign(to: \.monthlyAllowance, on: self)
            .store(in: &cancellables)
    }

    private func setupIncomingSection() {
        businessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularInbound } }
            .map { $0.sorted { $0.amount > $1.amount } }
            .map { ListSection(title: "Incoming", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.incomingSection, on: self)
            .store(in: &cancellables)
    }

    private func setupOutgoingSection() {
        businessLogic.transactions
            .map { $0.filter { $0.source == .externalRegularOutbound } }
            .map { $0.sorted { $0.amount < $1.amount } }
            .map { ListSection(title: "Outgoing", rows: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.outgoingSection, on: self)
            .store(in: &cancellables)
    }
}
