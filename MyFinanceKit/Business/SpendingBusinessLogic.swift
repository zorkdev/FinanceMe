public struct SpendingBusinessLogic {

    public init() {}

    public func allowanceIcon(for user: User) -> String {
        switch user.allowance {
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
