public protocol TodayViewModelDelegate: ViewModelDelegate {
    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)
    func set(allowanceIcon: String)
}

public protocol TodayPresentable: ViewModelType {
    typealias ServiceProvider = NetworkServiceProvider & DataServiceProvider & SessionServiceProvider
    var serviceProvider: ServiceProvider { get }

    var displayModel: TodayDisplayModelType { get }
    var delegate: TodayViewModelDelegate? { get }

    @discardableResult
    func updateData() -> Promise<Void>
    func setupDefaults()
}

public extension TodayPresentable {
    func viewDidLoad() {
        setupDefaults()
    }

    @discardableResult
    func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getUser())
    }

    func setupDefaults() {
        guard let balance = Balance.load(dataService: serviceProvider.dataService),
            let user = User.load(dataService: serviceProvider.dataService) else { return }
        let balanceAttributedString = type(of: displayModel).attributedString(from: balance.effectiveBalance)
        delegate?.set(balance: balanceAttributedString)
        let allowanceAttributedString = type(of: displayModel).attributedString(from: user.allowance)
        let allowanceIcon = SpendingBusinessLogic().allowanceIcon(for: user)
        delegate?.set(allowance: allowanceAttributedString)
        delegate?.set(allowanceIcon: allowanceIcon)
    }

    @discardableResult
    func getBalance() -> Promise<Void> {
        return BalanceBusinessLogic(serviceProvider: serviceProvider)
            .getBalance().done { balance in
                let balanceAttributedString = type(of: self.displayModel).attributedString(from: balance.effectiveBalance)
                self.delegate?.set(balance: balanceAttributedString)
            }
    }

    @discardableResult
    func getUser() -> Promise<Void> {
        return UserBusinessLogic(serviceProvider: serviceProvider)
            .getCurrentUser().done { user in
                let allowanceAttributedString = type(of: self.displayModel).attributedString(from: user.allowance)
                let allowanceIcon = SpendingBusinessLogic().allowanceIcon(for: user)
                self.delegate?.set(allowance: allowanceAttributedString)
                self.delegate?.set(allowanceIcon: allowanceIcon)
            }
    }
}
