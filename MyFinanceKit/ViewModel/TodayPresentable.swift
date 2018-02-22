public protocol TodayViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)
    func set(allowanceIcon: String)

}

public protocol TodayPresentable: ViewModelType {

    var networkDataServiceProvider: NetworkDataServiceProvider { get }
    var displayModel: TodayDisplayModelType { get }
    var delegate: TodayViewModelDelegate? { get }

    @discardableResult func updateData() -> Promise<Void>
    func setupDefaults()

}

public extension TodayPresentable {

    public func viewDidLoad() {
        setupDefaults()
        updateData()
    }

    @discardableResult public func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getUser())
    }

    public func setupDefaults() {
        guard let balance = Balance.load(dataService: networkDataServiceProvider.dataService),
            let user = User.load(dataService: networkDataServiceProvider.dataService) else { return }
        let balanceAttributedString = createAttributedString(from: balance.effectiveBalance)
        delegate?.set(balance: balanceAttributedString)
        let allowanceAttributedString = createAttributedString(from: user.allowance)
        let spendingBusinessLogic = SpendingBusinessLogic(dataService: networkDataServiceProvider.dataService)
        let allowanceIcon = spendingBusinessLogic.allowanceIcon(for: user)
        delegate?.set(allowance: allowanceAttributedString)
        delegate?.set(allowanceIcon: allowanceIcon)
    }

    public func createAttributedString(from amount: Double) -> NSAttributedString {
        let currencyString = Formatters.currency
            .string(from: NSNumber(value: amount)) ?? displayModel.defaultAmount
        return displayModel.amountAttributedString(from: currencyString)
    }

    @discardableResult public func getBalance() -> Promise<Void> {
        return BalanceBusinessLogic(networkService: networkDataServiceProvider.networkService,
                                    dataService: networkDataServiceProvider.dataService)
            .getBalance().done { balance in
            let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
            self.delegate?.set(balance: balanceAttributedString)
        }
    }

    @discardableResult public func getUser() -> Promise<Void> {
        return UserBusinessLogic(networkService: networkDataServiceProvider.networkService,
                                 dataService: networkDataServiceProvider.dataService)
            .getCurrentUser().done { user in
                let allowanceAttributedString = self.createAttributedString(from: user.allowance)
                let spendingBusinessLogic =
                    SpendingBusinessLogic(dataService: self.networkDataServiceProvider.dataService)
                let allowanceIcon = spendingBusinessLogic.allowanceIcon(for: user)
                self.delegate?.set(allowance: allowanceAttributedString)
                self.delegate?.set(allowanceIcon: allowanceIcon)
        }
    }

}
