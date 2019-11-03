struct SpendingBusinessLogic {
    func icon(for allowance: Decimal) -> String {
        switch allowance {
        case -.greatestFiniteMagnitude ... -100: return "😱"
        case -100 ... -50: return "😨"
        case -50 ... -20: return "😰"
        case -20 ... 0: return "😓"
        case 0 ... 20: return "😳"
        case 20 ... 50: return "🤔"
        case 50 ... 100: return "😏"
        case 100 ... 200: return "😇"
        case 200 ... .greatestFiniteMagnitude: return "🤑"
        default: return ""
        }
    }
}
