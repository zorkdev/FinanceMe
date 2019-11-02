import SwiftUI

public struct RegularsView: View {
    private let appState: AppState
    @ObservedObject private var viewModel: RegularsViewModel

    public var body: some View {
        List {
            Section(header: Text("MONTHLY BALANCE")) {
                MonthlyBalanceView(monthlyBalance: viewModel.monthlyBalance)
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

    public init(appState: AppState, loadingState: LoadingState) {
        self.appState = appState
        self.viewModel = RegularsViewModel(loadingState: loadingState,
                                           userBusinessLogic: appState.userBusinessLogic,
                                           transactionBusinessLogic: appState.transactionBusinessLogic,
                                           summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct RegularsViewPreviews: PreviewProvider {
    static var previews: some View {
        RegularsView(appState: AppState.stub, loadingState: LoadingState())
            .previewLayout(.sizeThatFits)
    }
}
#endif
