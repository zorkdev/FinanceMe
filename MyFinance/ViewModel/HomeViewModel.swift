protocol HomeViewModelDelegate: class {

    func set(balance: String)
    func set(allowance: String)

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
        }.catch { error in
            print(error)
        }
    }

    func getSpending() {
        spendingBusinessLogic.getAllowanceThisWeek().then { allowance -> Void in
            let allowanceString = Formatters.format(amount: allowance)
            self.delegate?.set(allowance: allowanceString)
        }.catch { error in
            print(error)
        }
    }

}
