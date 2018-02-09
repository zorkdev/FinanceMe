public protocol TodayViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)

}

public protocol TodayPresentable: ViewModelType {

    var displayModel: TodayDisplayModelType { get }
    weak var delegate: TodayViewModelDelegate? { get }

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
        guard let balance = Balance.load(),
            let user = User.load() else { return }
        let balanceAttributedString = createAttributedString(from: balance.effectiveBalance)
        delegate?.set(balance: balanceAttributedString)
        let allowanceAttributedString = createAttributedString(from: user.allowance)
        delegate?.set(allowance: allowanceAttributedString)
    }

    public func createAttributedString(from amount: Double) -> NSAttributedString {
        let currencyString = Formatters.currency
            .string(from: NSNumber(value: amount)) ?? displayModel.defaultAmount
        return displayModel.amountAttributedString(from: currencyString)
    }

    @discardableResult public func getBalance() -> Promise<Void> {
        return BalanceBusinessLogic().getBalance().then { balance -> Void in
            let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
            self.delegate?.set(balance: balanceAttributedString)
        }
    }

    @discardableResult public func getUser() -> Promise<Void> {
        return UserBusinessLogic().getCurrentUser().then { user -> Void in
            let allowanceAttributedString = self.createAttributedString(from: user.allowance)
            self.delegate?.set(allowance: allowanceAttributedString)
        }
    }

}
