import SwiftUI

public struct RegularsView: View {
    @ObservedObject private var viewModel: RegularsViewModel

    public var body: some View {
        List {
            Section {
                TransactionView(narrative: viewModel.monthlyAllowance.title,
                                amount: viewModel.monthlyAllowance.amount,
                                signs: [])
            }
            Section(header: Text(viewModel.incomingSection.title.uppercased())) {
                ForEach(viewModel.incomingSection.rows) { transaction in
                    TransactionView(narrative: transaction.narrative, amount: transaction.amount)
                }
            }
            Section(header: Text(viewModel.outgoingSection.title.uppercased())) {
                ForEach(viewModel.outgoingSection.rows) { transaction in
                    TransactionView(narrative: transaction.narrative, amount: transaction.amount)
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
