import SwiftUI

public struct BalancesView: View {
    @ObservedObject private var viewModel: BalancesViewModel

    public var body: some View {
        List {
            Section(header: Text("THIS MONTH")) {
                CurrentMonthView(currentMonth: viewModel.currentMonth)
            }
            ForEach(viewModel.summarySections) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.rows) {
                        TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative,
                                                                        amount: $0.amount,
                                                                        signs: [.plus, .minus]))
                    }
                }
            }
        }
    }

    public init(appState: AppState) {
        self.viewModel = BalancesViewModel(businessLogic: appState.summaryBusinessLogic)
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
