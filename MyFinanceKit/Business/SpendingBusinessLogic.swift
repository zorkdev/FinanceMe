public struct SpendingBusinessLogic {

    //swiftlint:disable:next cyclomatic_complexity
    public func allowanceIcon(for user: User) -> String {
        guard let allowance = User.load()?.allowance else { return "" }

        switch allowance {
        case -Double.greatestFiniteMagnitude ... -100: return "😱"
        case -100 ... -50: return "😨"
        case -50 ... -20: return "😰"
        case -20 ... 0: return "😓"
        case 0 ... 20: return "😳"
        case 20 ... 50: return "🤔"
        case 50 ... 100: return "😏"
        case 100 ... 200: return "😇"
        case 200 ... Double.greatestFiniteMagnitude: return "🤑"
        default: return ""
        }
    }

}
