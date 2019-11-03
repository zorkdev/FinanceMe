import SwiftUI

struct TransactionDetailView: View {
    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: TransactionDetailViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Amount")
                        TextField("£0.00", text: $viewModel.amount, onEditingChanged: viewModel.onAmountEditingChanged)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Description")
                        TextField("Groceries", text: $viewModel.narrative)
                            .autocapitalization(.words)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(Transaction.Source.allCases, id: \.self) { Text($0.displayString) }
                    }
                    DatePicker("Date", selection: $viewModel.date)
                }
            }
            .navigationBarTitle("Transaction Details")
            .navigationBarItems(leading: Button("Cancel") { self.presentationMode.wrappedValue.dismiss() },
                                trailing: Button("Save", action: viewModel.onSave).disabled(viewModel.isDisabled))
        }
        .loading(loadingState)
        .errorBanner(errorViewModel)
        .dismiss(shouldDismiss: $viewModel.shouldDismiss)
    }

    init(transaction: Transaction?, appState: AppState) {
        self.viewModel = TransactionDetailViewModel(transaction: transaction,
                                                    loadingState: loadingState,
                                                    errorViewModel: errorViewModel,
                                                    userBusinessLogic: appState.userBusinessLogic,
                                                    transactionBusinessLogic: appState.transactionBusinessLogic,
                                                    summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct TransactionDetailViewPreviews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transaction: nil, appState: AppState.stub)
    }
}
#endif
