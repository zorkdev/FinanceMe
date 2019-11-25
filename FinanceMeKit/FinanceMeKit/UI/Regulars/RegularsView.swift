import SwiftUI

struct RegularsView: View {
    private let appState: AppState
    @ObservedObject private var viewModel: RegularsViewModel

    var body: some View {
        List {
            Section(header: Text("MONTHLY BALANCE")) {
                MonthlyBalanceView(monthlyBalance: viewModel.monthlyBalance)
            }
            Section(header: Text(viewModel.savingsSection.title.uppercased())) {
                // SwiftUI bug: One more ForEach in a View crashes
                // ForEach(viewModel.savingsSection.rows) {
                if viewModel.savingsSection.rows.first != nil {
                    TransactionNavigationView(transaction: self.viewModel.savingsSection.rows.first!,
                                              appState: self.appState)
                }
                // .onDelete { self.viewModel.onDelete(section: self.viewModel.savingsSection, row: $0) }
            }
            Section(header: Text(viewModel.incomingSection.title.uppercased())) {
                ForEach(viewModel.incomingSection.rows) {
                    TransactionNavigationView(transaction: $0, appState: self.appState)
                }
                .onDelete { self.viewModel.onDelete(section: self.viewModel.incomingSection, row: $0) }
            }
            Section(header: Text(viewModel.outgoingSection.title.uppercased())) {
                ForEach(viewModel.outgoingSection.rows) {
                    TransactionNavigationView(transaction: $0, appState: self.appState)
                }
                .onDelete { self.viewModel.onDelete(section: self.viewModel.outgoingSection, row: $0) }
            }
        }
    }

    init(appState: AppState,
         loadingState: LoadingState,
         errorViewModel: ErrorViewModel) {
        self.appState = appState
        self.viewModel = RegularsViewModel(loadingState: loadingState,
                                           errorViewModel: errorViewModel,
                                           userBusinessLogic: appState.userBusinessLogic,
                                           transactionBusinessLogic: appState.transactionBusinessLogic,
                                           summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct RegularsViewPreviews: PreviewProvider {
    static var previews: some View {
        RegularsView(appState: AppState.stub, loadingState: LoadingState(), errorViewModel: ErrorViewModel())
            .previewLayout(.sizeThatFits)
    }
}
#endif
