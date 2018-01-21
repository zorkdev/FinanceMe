protocol HomeViewModelDelegate: class {

    func set(balance: String)
    func set(allowance: String)

}

class HomeViewModel {

    private struct Constants {
        static let defaultAmount = "£0.00"
    }

    let balanceBusinessLogic = BalanceBusinessLogic()
    let spendingBusinessLogic = SpendingBusinessLogic()
    let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()

    weak var delegate: HomeViewModelDelegate?

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        getBalance()
        getSpending()
        //getExternalTransactions()
    }

    func getBalance() {
        balanceBusinessLogic.getBalance().then { balance -> Void in
            let balanceString = Formatters.currency
                .string(from: NSNumber(value: balance.effectiveBalance)) ?? Constants.defaultAmount
            self.delegate?.set(balance: balanceString)
        }.catch { error in
            print(error)
        }
    }

    func getSpending() {
        spendingBusinessLogic.calculateAllowanceThisWeek().then { allowance -> Void in
            let allowanceString = Formatters.currency
                .string(from: NSNumber(value: allowance)) ?? Constants.defaultAmount
            self.delegate?.set(allowance: allowanceString)
        }.catch { error in
            print(error)
        }
    }

    func getExternalTransactions() {
        externalTransactionsBusinessLogic.getExternalTransactions().then { transactions in
            print(transactions)
        }.catch { error in
            print(error)
        }
    }

}
