struct TransactionViewModel {
    let narrative: String
    let amountViewModel: AmountViewModel

    init(narrative: String, amount: Decimal, signs: [AmountViewModel.Sign] = [.plus]) {
        self.narrative = narrative
        self.amountViewModel = AmountViewModel(value: amount, signs: signs)
    }
}
