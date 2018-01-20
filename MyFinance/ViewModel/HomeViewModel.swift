import Foundation

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
        balanceBusinessLogic.getBalance { [weak self] _, balance in
            guard let balance = balance else { return }
            let balanceString = Formatters.format(amount: balance.effectiveBalance)
            self?.delegate?.set(balance: balanceString)
        }
    }

    func getSpending() {
        spendingBusinessLogic.getSpendingThisWeek { [weak self] _, spending in
            guard let spending = spending else { return }
            let spendingString = Formatters.format(amount: spending)
            self?.delegate?.set(spending: spendingString)
        }
    }

}
