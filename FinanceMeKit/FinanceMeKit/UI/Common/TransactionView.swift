import SwiftUI

struct TransactionView: View {
    private let viewModel: TransactionViewModel

    var body: some View {
        HStack {
            Text(viewModel.narrative)
            Spacer()
            Text(viewModel.amountViewModel.string)
                .foregroundColor(viewModel.amountViewModel.color)
        }
        .accessibilityElement(children: .combine)
    }

    init(viewModel: TransactionViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct TransactionViewPreviews: PreviewProvider {
    static var previews: some View {
        TransactionView(viewModel: TransactionViewModel(narrative: "Transaction", amount: -110.42))
            .previewLayout(.sizeThatFits)
    }
}
#endif
