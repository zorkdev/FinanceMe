import MyFinanceKit

class MockTodayViewModelDelegate: TodayViewModelDelegate {

    var lastBalance: NSAttributedString?
    var lastAllowance: NSAttributedString?
    var lastAllowanceIcon: String?

    func set(balance: NSAttributedString) {
        lastBalance = balance
    }

    func set(allowance: NSAttributedString) {
        lastAllowance = allowance
    }

    func set(allowanceIcon: String) {
        lastAllowanceIcon = allowanceIcon
    }

}
