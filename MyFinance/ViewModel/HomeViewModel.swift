protocol HomeViewModelDelegate: class {

    func set(balance: String)
    func set(spending: String)

}

class HomeViewModel {

    let balanceBusinessLogic = BalanceBusinessLogic()
    let spendingBusinessLogic = SpendingBusinessLogic()

    weak var delegate: HomeViewModelDelegate?

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        getBalance()
        getSpending()
    }

    func getBalance() {
        balanceBusinessLogic.getBalance().then { balance -> Void in
            let balanceString = Formatters.format(amount: balance.effectiveBalance)
            self.delegate?.set(balance: balanceString)
        }
    }

    func getSpending() {
        spendingBusinessLogic.getSpendingThisWeek().then { spending -> Void in
            let spendingString = Formatters.format(amount: spending)
            self.delegate?.set(spending: spendingString)
        }
    }

}
