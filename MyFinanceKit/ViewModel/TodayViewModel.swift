import Foundation
import PromiseKit

public protocol TodayViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)

}

public protocol TodayDisplayModelType {

    var defaultAmount: String { get }
    func amountAttributedString(from string: String) -> NSAttributedString

}

public class TodayViewModel {

    let balanceBusinessLogic = BalanceBusinessLogic()
    let userBusinessLogic = UserBusinessLogic()

    let displayModel: TodayDisplayModelType

    weak var delegate: TodayViewModelDelegate?

    public init(delegate: TodayViewModelDelegate, displayModel: TodayDisplayModelType) {
        self.delegate = delegate
        self.displayModel = displayModel
    }

    public func viewDidLoad() {
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

    @discardableResult public func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getUser())
    }

}
