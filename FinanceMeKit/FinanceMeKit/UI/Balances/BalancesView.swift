import SwiftUI

struct BalancesView: View {
    @ObservedObject private var viewModel: BalancesViewModel

    var body: some View {
        List {
            Section(header: Text("THIS MONTH")) {
                CurrentMonthView(currentMonth: viewModel.currentMonth)
            }
            ForEach(viewModel.summarySections) { section in
                Section(header: self.summaryHeader(title: section.title)) {
                    ForEach(section.rows) {
                        EndOfMonthSummaryView(viewModel: $0)
                    }
                }
            }
        }
    }

    init(appState: AppState) {
        self.viewModel = BalancesViewModel(businessLogic: appState.summaryBusinessLogic)
    }
}

private extension BalancesView {
    func summaryHeader(title: String) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
            Text("Balance".uppercased())
            Text("Savings".uppercased())
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct BalancesViewPreviews: PreviewProvider {
    static var previews: some View {
        BalancesView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
