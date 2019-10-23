public struct TransactionViewModel {
    public let narrative: String
    public let amountViewModel: AmountViewModel

    public init(narrative: String, amount: Decimal, signs: [AmountViewModel.Sign] = [.plus]) {
        self.narrative = narrative
        self.amountViewModel = AmountViewModel(value: amount, signs: signs)
    }
}
