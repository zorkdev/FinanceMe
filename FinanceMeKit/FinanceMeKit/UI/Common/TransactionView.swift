import SwiftUI

public struct TransactionView: View {
    private let viewModel: TransactionViewModel

    public var body: some View {
        HStack {
            Text(viewModel.narrative)
            Spacer()
            Text(viewModel.amountViewModel.string)
                .foregroundColor(viewModel.amountViewModel.color)
        }
    }

    public init(viewModel: TransactionViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct TransactionViewPreviews: PreviewProvider {
    static var previews: some View {
        TransactionView(viewModel: TransactionViewModel(narrative: "Transaction", amount: -110.42))
            .previewLayout(.sizeThatFits)
    }
}
#endif
