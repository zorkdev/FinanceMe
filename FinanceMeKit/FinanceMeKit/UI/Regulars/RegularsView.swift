import SwiftUI

public struct RegularsView: View {
    @ObservedObject private var viewModel: RegularsViewModel

    public var body: some View {
        List {
            Section(header: Text("MONTHLY BALANCE")) {
                HStack {
                    VStack(alignment: .leading) {
                        AmountView(viewModel: AmountViewModel(value: viewModel.monthlyBalance.allowance,
                                                              signs: [.plus, .minus]))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Text("ALLOWANCE").font(.caption).foregroundColor(Color.secondary)
                    }
                    VStack(alignment: .trailing) {
                        AmountView(viewModel: AmountViewModel(value: viewModel.monthlyBalance.outgoings,
                                                              signs: [.plus, .minus]))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        Text("OUTGOINGS").font(.caption).foregroundColor(Color.secondary)
                    }
                }
                .padding([.top, .bottom])
            }
            Section(header: Text(viewModel.incomingSection.title.uppercased())) {
                ForEach(viewModel.incomingSection.rows) {
                    TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative, amount: $0.amount))
                }
            }
            Section(header: Text(viewModel.outgoingSection.title.uppercased())) {
                ForEach(viewModel.outgoingSection.rows) {
                    TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative, amount: $0.amount))
                }
            }
        }
    }

    public init(appState: AppState) {
        self.viewModel = RegularsViewModel(businessLogic: appState.transactionBusinessLogic)
    }
}

#if DEBUG
struct RegularsViewPreviews: PreviewProvider {
    static var previews: some View {
        RegularsView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
