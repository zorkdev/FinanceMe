import Foundation
import PromiseKit

public protocol TodayDisplayModelType {

    var defaultAmount: String { get }
    func amountAttributedString(from string: String) -> NSAttributedString

}

public extension TodayDisplayModelType {

    var defaultAmount: String { return "£0.00" }

}

public protocol TodayViewModelDelegate: class {

    func set(balance: NSAttributedString)
    func set(allowance: NSAttributedString)

}

public protocol TodayPresentable: ViewModelType {

    var displayModel: TodayDisplayModelType { get }
    weak var delegate: TodayViewModelDelegate? { get }

    @discardableResult func updateData() -> Promise<Void>
    func setupDefaults()

}

public extension TodayPresentable {

    public func viewDidLoad() {
        setupDefaults()
        updateData()
    }

    @discardableResult public func updateData() -> Promise<Void> {
        return when(fulfilled: getBalance(), getUser())
    }

    public func setupDefaults() {
        let balanceAttributedString = createAttributedString(from: DataManager.shared.balance)
        let allowanceAttributedString = createAttributedString(from: DataManager.shared.allowance)
        delegate?.set(balance: balanceAttributedString)
        delegate?.set(allowance: allowanceAttributedString)
    }

}

// MARK: - Private methods

private extension TodayPresentable {

    private func createAttributedString(from amount: Double) -> NSAttributedString {
        let currencyString = Formatters.currency
            .string(from: NSNumber(value: amount)) ?? displayModel.defaultAmount
        return displayModel.amountAttributedString(from: currencyString)
    }

    private func getBalance() -> Promise<Void> {
        return BalanceBusinessLogic().getBalance().then { balance -> Void in
            let balanceAttributedString = self.createAttributedString(from: balance.effectiveBalance)
            self.delegate?.set(balance: balanceAttributedString)
        }
    }

    private func getUser() -> Promise<Void> {
        return UserBusinessLogic().getCurrentUser().then { user -> Void in
            let allowanceAttributedString = self.createAttributedString(from: user.allowance)
            self.delegate?.set(allowance: allowanceAttributedString)
        }
    }

}
