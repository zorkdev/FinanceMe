protocol TodayViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)

}

struct TodayDisplayModel {

    let defaultAmount = Formatters.format(amount: 0)

    func amountAttributedString(from string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes:
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40, weight: .light)])
        attributedString.addAttributes(
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .regular)],
            range: NSRange(location: 0, length: 1))
        attributedString.addAttributes(
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .regular)],
            range: NSRange(location: string.count - 3, length: 3))

        return attributedString
    }

}

class TodayViewModel {

    let balanceBusinessLogic = BalanceBusinessLogic()
    let spendingBusinessLogic = SpendingBusinessLogic()

    var displayModel = TodayDisplayModel()

    weak var delegate: TodayViewModelDelegate?

    init(delegate: TodayViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        setDefaultAmounts()
        updateData()
    }

    func setDefaultAmounts() {
        let attributedString = self.displayModel
            .amountAttributedString(from: displayModel.defaultAmount)
        self.delegate?.set(balance: attributedString)
        self.delegate?.set(allowance: attributedString)
    }

    func getBalance() -> Promise<Void> {
        return balanceBusinessLogic.getBalance().then { balance -> Void in
            let balanceString = Formatters.format(amount: balance.effectiveBalance)
            let balanceAttributedString = self.displayModel.amountAttributedString(from: balanceString)
            self.delegate?.set(balance: balanceAttributedString)
        }
    }

    func getAllowance() -> Promise<Void> {
        return spendingBusinessLogic.getAllowanceThisWeek().then { allowance -> Void in
            let allowanceString = Formatters.format(amount: allowance)
            let allowanceAttributedString = self.displayModel.amountAttributedString(from: allowanceString)
            self.delegate?.set(allowance: allowanceAttributedString)
        }
    }

    @discardableResult func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getAllowance())
    }

}
