protocol HomeViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)
    func reloadTableView()

}

struct HomeDisplayModel {

    let defaultAmount = "£0.00"

    func amountAttributedString(from string: String) -> NSAttributedString {
        let isNegative = string.first == "-"
        let positiveColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
        let negativeColor = UIColor(red: 205/255.0, green: 65/255.0, blue: 75/255.0, alpha: 1.0)
        let color = isNegative ? negativeColor : positiveColor

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

class HomeViewModel {

    let balanceBusinessLogic = BalanceBusinessLogic()
    let spendingBusinessLogic = SpendingBusinessLogic()
    let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic()

    let displayModel = HomeDisplayModel()

    weak var delegate: HomeViewModelDelegate?

    var externalTransactions = [Transaction]()

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func viewDidLoad() {
        setupDefaults()
        getBalance()
        getSpending()
        getExternalTransactions()
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

    func getBalance() {
        balanceBusinessLogic.getBalance().then { balance -> Void in
            let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
            self.delegate?.set(balance: balanceAttributedString)
        }.catch { error in
            print(error)
        }
    }

    func getSpending() {
        spendingBusinessLogic.calculateAllowanceThisWeek().then { allowance -> Void in
            let allowanceAttributedString = self.createAttributedString(from: allowance)
            self.delegate?.set(allowance: allowanceAttributedString)
        }.catch { error in
            print(error)
        }
    }

    func getExternalTransactions() {
        externalTransactionsBusinessLogic.getExternalTransactions().then { transactions -> Void in
            self.externalTransactions = transactions.sorted(by: { $0.amount > $1.amount })
            self.delegate?.reloadTableView()
        }.catch { error in
            print(error)
        }
    }

}
