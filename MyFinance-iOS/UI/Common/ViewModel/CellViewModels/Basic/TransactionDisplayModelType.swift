protocol TransactionPresentable {

    var narrative: String { get }
    var amount: String { get }
    var amountColor: Color { get }
    var canEdit: Bool { get }

}

protocol TransactionDisplayModelType {

    var amountDisplayModel: AmountDisplayModelType { get }

}

struct NormalTransactionDisplayModel: TransactionPresentable, TransactionDisplayModelType {

    let narrative: String
    let amount: String
    let amountColor: Color
    let canEdit = true
    let amountDisplayModel: AmountDisplayModelType = .plus

    init(transaction: Transaction) {
        narrative = transaction.narrative
        amount = amountDisplayModel.formatter.string(from: transaction.amount)
        amountColor = amountDisplayModel.color(forAmount: transaction.amount)
    }

}

struct MonthlyAllowanceDisplayModel: TransactionPresentable, TransactionDisplayModelType {

    let narrative = "Monthly Allowance"
    let amount: String
    let amountColor: Color
    let canEdit = false
    let amountDisplayModel: AmountDisplayModelType = .minus

    init(amount: Double) {
        self.amount = amountDisplayModel.formatter.string(from: amount)
        amountColor = amountDisplayModel.color(forAmount: amount)
    }

}

struct EndOfMonthSummaryDisplayModel: TransactionPresentable, TransactionDisplayModelType {

    let narrative: String
    let amount: String
    let amountColor: Color
    let canEdit = false
    let amountDisplayModel: AmountDisplayModelType = .plusMinus

    init(date: Date, amount: Double) {
        narrative = Formatters.month.string(from: date)
        self.amount = amountDisplayModel.formatter.string(from: amount)
        amountColor = amountDisplayModel.color(forAmount: amount)
    }

}
