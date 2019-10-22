import SwiftUI

public struct TransactionView: View {
    private let narrative: String
    private let amount: Decimal
    private let signs: [AmountViewModel.Sign]

    public var body: some View {
        HStack {
            Text(narrative)
            Spacer()
            Text(AmountViewModel(value: amount, signs: signs).string)
                .foregroundColor(amountColor)
        }
    }

    private var amountColor: Color? {
        let isNegative = AmountViewModel(value: amount).isNegative

        if isNegative, signs.contains(.minus) {
            return .red
        } else if isNegative == false, signs.contains(.plus) {
            return .green
        }

        return nil
    }

    public init(narrative: String, amount: Decimal, signs: [AmountViewModel.Sign] = [.plus]) {
        self.narrative = narrative
        self.amount = amount
        self.signs = signs
    }
}

#if DEBUG
struct TransactionViewPreviews: PreviewProvider {
    static var previews: some View {
        TransactionView(narrative: "Transaction", amount: -110.42)
            .previewLayout(.sizeThatFits)
    }
}
#endif
