import SwiftUI

public struct RegularsView: View {
    @ObservedObject private var viewModel: RegularsViewModel
    @State private var isDetailPresented = false

    public var body: some View {
        List {
            Section(header: Text("MONTHLY BALANCE")) {
                MonthlyBalanceView(monthlyBalance: viewModel.monthlyBalance)
            }
            Section(header: Text(viewModel.incomingSection.title.uppercased())) {
                ForEach(viewModel.incomingSection.rows) {
                    TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative, amount: $0.amount))
                        .onTapGesture { self.isDetailPresented = true }
                        .sheet(isPresented: self.$isDetailPresented) { Text("Transaction details") }
                }
                .onDelete { self.viewModel.onDelete(section: self.viewModel.incomingSection, row: $0) }
            }
            Section(header: Text(viewModel.outgoingSection.title.uppercased())) {
                ForEach(viewModel.outgoingSection.rows) {
                    TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative, amount: $0.amount))
                        .onTapGesture { self.isDetailPresented = true }
                        .sheet(isPresented: self.$isDetailPresented) { Text("Transaction details") }
                }
                .onDelete { self.viewModel.onDelete(section: self.viewModel.outgoingSection, row: $0) }
            }
        }
    }

    public init(appState: AppState) {
        self.viewModel = RegularsViewModel(userBusinessLogic: appState.userBusinessLogic,
                                           transactionBusinessLogic: appState.transactionBusinessLogic,
                                           summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct RegularsViewPreviews: PreviewProvider {
    static var previews: some View {
        RegularsView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
