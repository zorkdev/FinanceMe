import SwiftUI

struct TransactionDetailView: View {
    private static let width: CGFloat = 80

    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: TransactionDetailViewModel

    var body: some View {
        Form {
            VStack {
                HStack {
                    Text("Amount:").frame(minWidth: Self.width, alignment: .trailing)
                    TextField("£0.00", text: $viewModel.amount, onEditingChanged: viewModel.onAmountEditingChanged)
                }
                HStack {
                    Text("Description:").frame(minWidth: Self.width, alignment: .trailing)
                    TextField("Groceries", text: $viewModel.narrative)
                }
                Picker(selection: $viewModel.category,
                       label: Text("Category:").frame(minWidth: Self.width, alignment: .trailing)) {
                    ForEach(Transaction.Source.allCases, id: \.self) { Text($0.displayString) }
                }
                DatePicker(selection: $viewModel.date) {
                    Text("Date:").frame(minWidth: Self.width, alignment: .trailing)
                }
                Divider()
                HStack {
                    Button("Cancel") { self.presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    Button("Save", action: self.viewModel.onSave)
                        .disabled(viewModel.isDisabled)
                }
            }
        }
        .padding()
        .frame(idealWidth: 350)
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
