protocol TodayViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)

}

struct TodayDisplayModel {

    let defaultAmount = "£0.00"

    func amountAttributedString(from string: String) -> NSAttributedString {
        let isNegative = string.first == "-"
        let color = isNegative ? UIColor.red : UIColor.darkText

        let attributedString = NSMutableAttributedString(string: string, attributes:
            [.font: UIFont.systemFont(ofSize: 40, weight: .light),
             .foregroundColor: color])
        let length = isNegative ? 2 : 1
        attributedString.addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .regular)],
            range: NSRange(location: 0, length: length))
        attributedString.addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .regular)],
            range: NSRange(location: string.count - 3, length: 3))

        return attributedString
    }

}

class TodayViewModel {

    let balanceBusinessLogic = BalanceBusinessLogic()
    let userBusinessLogic = UserBusinessLogic()

    let displayModel = TodayDisplayModel()

    weak var delegate: TodayViewModelDelegate?

    init(delegate: TodayViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        setupDefaults()
        updateData()
    }

    func setupDefaults() {
        let balanceAttributedString = createAttributedString(from: DataManager.shared.balance)
        let allowanceAttributedString = createAttributedString(from: DataManager.shared.allowance)
        delegate?.set(balance: balanceAttributedString)
        delegate?.set(allowance: allowanceAttributedString)
    }

    func createAttributedString(from amount: Double) -> NSAttributedString {
        let currencyString = Formatters.currency
            .string(from: NSNumber(value: amount)) ?? displayModel.defaultAmount
        return displayModel.amountAttributedString(from: currencyString)
    }

    func getBalance() -> Promise<Void> {
        return balanceBusinessLogic.getBalance().then { balance -> Void in
            let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
            self.delegate?.set(balance: balanceAttributedString)
        }
    }

    func getUser() -> Promise<Void> {
        return userBusinessLogic.getCurrentUser().then { user -> Void in
            let allowanceAttributedString = self.createAttributedString(from: user.allowance)
            self.delegate?.set(allowance: allowanceAttributedString)
        }
    }

    @discardableResult func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getUser())
    }

}
