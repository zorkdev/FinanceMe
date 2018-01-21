protocol TodayViewModelDelegate: class {

    func set(balance: String)
    func set(allowance: String)

}

class TodayViewModel {

    let balanceBusinessLogic = BalanceBusinessLogic()
    let spendingBusinessLogic = SpendingBusinessLogic()

    weak var delegate: TodayViewModelDelegate?

    init(delegate: TodayViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        updateData()
    }

    func getBalance() -> Promise<Void> {
        return balanceBusinessLogic.getBalance().then { balance -> Void in
            let balanceString = Formatters.format(amount: balance.effectiveBalance)
            self.delegate?.set(balance: balanceString)
        }
    }

    func getAllowance() -> Promise<Void> {
        return spendingBusinessLogic.getAllowanceThisWeek().then { allowance -> Void in
            let allowanceString = Formatters.format(amount: allowance)
            self.delegate?.set(allowance: allowanceString)
        }
    }

    @discardableResult func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getAllowance())
    }

}
