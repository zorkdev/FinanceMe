import Combine

public class SettingsViewModel: ObservableObject {
    private static let formatter = Formatters.currency

    private let sessionBusinessLogic: SessionBusinessLogicType
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private var user: User?
    private var cancellables: Set<AnyCancellable> = []

    @Published public var name = ""
    @Published public var limit = ""
    @Published public var payday = 1
    @Published public var date = Date()
    @Published public var isEditing = false
    @Published public var isDisabled = true
    @Published public var shouldDismiss = false

    public let paydays = Array(1...28)

    private var limitValue: Decimal? { Self.formatter.decimal(from: limit) }

    private var newUser: User? {
        guard let user = user,
            let limitValue = limitValue else { return nil }

        return User(name: name,
                    payday: payday,
                    startDate: date,
                    largeTransaction: limitValue,
                    allowance: user.allowance,
                    balance: user.balance)
    }

    public init(sessionBusinessLogic: SessionBusinessLogicType,
                userBusinessLogic: UserBusinessLogicType,
                transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.sessionBusinessLogic = sessionBusinessLogic
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        setupBindings()
    }

    private func setupBindings() {
        userBusinessLogic.user
            .receive(on: DispatchQueue.main)
            .sink { user in
                guard let user = user else { return }
                self.user = user
                self.name = user.name
                self.limit = Self.formatter.string(from: user.largeTransaction)
                self.payday = user.payday
                self.date = user.startDate
            }.store(in: &cancellables)

        $isEditing
            .receive(on: DispatchQueue.main)
            .sink { isEditing in
                guard isEditing == false,
                    let user = self.user else { return }
                self.name = user.name
                self.limit = Self.formatter.string(from: user.largeTransaction)
                self.payday = user.payday
                self.date = user.startDate
            }.store(in: &cancellables)

        Publishers.CombineLatest4($name, $limit, $payday, $date)
            .receive(on: DispatchQueue.main)
            .map { _ in
                guard let newUser = self.newUser else { return true }
                return newUser == self.user
            }.assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }

    func onLimitEditingChanged(isEditing: Bool) {
        if let limitValue = limitValue {
            limit = Self.formatter.string(from: limitValue)
        } else {
            limit = ""
        }
    }

    func onSave() {
        guard let newUser = newUser else { return }

        userBusinessLogic.update(user: newUser)
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {
                self.shouldDismiss = true
            })
            .store(in: &cancellables)
    }

    func onReconcile() {
        transactionBusinessLogic.reconcile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }

    func onLogOut() {
        sessionBusinessLogic.logOut()
    }
}
