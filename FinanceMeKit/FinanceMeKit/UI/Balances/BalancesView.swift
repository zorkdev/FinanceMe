import SwiftUI

public struct BalancesView: View {
    @ObservedObject private var viewModel: BalancesViewModel

    public var body: some View {
        List {
            Section(header: Text("THIS MONTH")) {
                HStack {
                    VStack(alignment: .leading) {
                        AmountView(viewModel: AmountViewModel(value: viewModel.currentMonth.forecast,
                                                              signs: [.plus, .minus]))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Text("FORECAST").font(.caption).foregroundColor(Color.secondary)
                    }
                    VStack {
                        AmountView(viewModel: AmountViewModel(value: viewModel.currentMonth.spending,
                                                              signs: [.plus, .minus]))
                        Text("SPENDING").font(.caption).foregroundColor(Color.secondary)
                    }
                    VStack(alignment: .trailing) {
                        AmountView(viewModel: AmountViewModel(value: viewModel.currentMonth.allowance,
                                                              signs: [.plus, .minus]))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        Text("ALLOWANCE").font(.caption).foregroundColor(Color.secondary)
                    }
                }
                .padding([.top, .bottom])
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
struct BalancesViewPreviews: PreviewProvider {
    static var previews: some View {
        BalancesView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
