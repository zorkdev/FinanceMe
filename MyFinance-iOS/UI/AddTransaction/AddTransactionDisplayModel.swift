struct AddTransactionDisplayModel {

    static let buttonEnabledAlpha: CGFloat = 1.0
    static let buttonDisabledAlpha: CGFloat = 0.5
    static let buttonAnimationDuration = 0.2
    static let successMessage = "Your transaction has been saved!"

    let amount: String
    let narrative: String
    let source: Int
    let created: Date

    static func dateString(from date: Date) -> String {
        return Formatters.dateTime.string(from: date)
    }

}
