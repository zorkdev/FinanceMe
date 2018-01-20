import Foundation

protocol BalanceViewModelDelegate: class {

    func set(balance: String)

}

class BalanceViewModel {

    let businessLogic = BalanceBusinessLogic()

    weak var delegate: BalanceViewModelDelegate?

    init(delegate: BalanceViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        businessLogic.getBalance { [weak self] _, balance in
            guard let balance = balance else { return }
            let balanceString = AmountFormatter.format(amount: balance.effectiveBalance)
            self?.delegate?.set(balance: balanceString)
        }
    }

}
