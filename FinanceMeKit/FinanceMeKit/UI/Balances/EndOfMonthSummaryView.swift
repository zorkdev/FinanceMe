import SwiftUI

struct EndOfMonthSummaryView: View {
    private let viewModel: EndOfMonthSummaryViewModel

    var body: some View {
        HStack(spacing: .zero) {
            Text(viewModel.narrative)
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
            Text(viewModel.balanceViewModel.string)
                .foregroundColor(viewModel.balanceViewModel.color)
            Text(viewModel.savingsViewModel.string)
                .foregroundColor(viewModel.savingsViewModel.color)
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
    }

    init(viewModel: EndOfMonthSummaryViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct EndOfMonthSummaryViewPreviews: PreviewProvider {
    static var previews: some View {
        EndOfMonthSummaryView(viewModel: EndOfMonthSummaryViewModel(summary:
            EndOfMonthSummary(balance: -10, savings: 100, created: Date())))
            .previewLayout(.sizeThatFits)
    }
}
#endif
