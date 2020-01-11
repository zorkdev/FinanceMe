import Combine

final class SettingsViewModel: ObservableObject {
    private static let formatter = Formatters.currency

    private let sessionBusinessLogic: SessionBusinessLogicType
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    private var user: User?
    private var cancellables: Set<AnyCancellable> = []

    @Published var name = ""
    @Published var limit = ""
    @Published var payday = 1
    @Published var date = Date()
    @Published var isEditing = false
    @Published var isDisabled = true
    @Published var shouldDismiss = false

    let paydays = Array(1...28)

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

    init(sessionBusinessLogic: SessionBusinessLogicType,
         userBusinessLogic: UserBusinessLogicType,
         transactionBusinessLogic: TransactionBusinessLogicType,
         summaryBusinessLogic: SummaryBusinessLogicType,
         loadingState: LoadingState,
         errorViewModel: ErrorViewModel) {
        self.sessionBusinessLogic = sessionBusinessLogic
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.loadingState = loadingState
        self.errorViewModel = errorViewModel
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

        loadingState.isLoading = true

        userBusinessLogic.update(user: newUser)
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables) {
                self.shouldDismiss = true
            }
    }

    func onReconcile() {
        loadingState.isLoading = true

        transactionBusinessLogic.reconcile()
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables)
    }

    func onLogOut() {
        sessionBusinessLogic.logOut()
    }
}
