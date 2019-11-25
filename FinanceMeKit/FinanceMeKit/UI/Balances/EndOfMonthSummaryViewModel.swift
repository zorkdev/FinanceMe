struct EndOfMonthSummaryViewModel: Identifiable, Equatable {
    let summary: EndOfMonthSummary
    var narrative: String { Formatters.month.string(from: summary.created) }
    var balanceViewModel: AmountViewModel { AmountViewModel(value: summary.balance, signs: [.plus, .minus]) }
    var savingsViewModel: AmountViewModel { AmountViewModel(value: summary.savings, signs: [.plus, .minus]) }
    var id: Date { summary.created }
}
