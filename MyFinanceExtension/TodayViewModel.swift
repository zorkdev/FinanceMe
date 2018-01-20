protocol TodayViewModelDelegate: class {

    func set(balance: String)
    func set(spending: String)

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

    func getSpending() -> Promise<Void> {
        return spendingBusinessLogic.getSpendingThisWeek().then { spending -> Void in
            let spendingString = Formatters.format(amount: spending)
            self.delegate?.set(spending: spendingString)
        }
    }

    @discardableResult func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getSpending())
    }

}
