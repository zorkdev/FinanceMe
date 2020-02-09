import SwiftUI

struct TransactionDetailView: View {
    private static let width: CGFloat = 80

    private weak var window: NSWindow?
    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
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
                    Spacer()
                    LoadingView(loadingState)
                    Button("Save", action: self.viewModel.onSave)
                        .disabled(viewModel.isDisabled)
                }
            }
        }
        .padding()
        .frame(idealWidth: 350)
        .errorBanner(errorViewModel)
        .dismiss(shouldDismiss: $viewModel.shouldDismiss, window: window)
    }

    init(transaction: Transaction?, appState: AppState) {
        self.viewModel = TransactionDetailViewModel(transaction: transaction,
                                                    loadingState: loadingState,
                                                    errorViewModel: errorViewModel,
                                                    userBusinessLogic: appState.userBusinessLogic,
                                                    transactionBusinessLogic: appState.transactionBusinessLogic,
                                                    summaryBusinessLogic: appState.summaryBusinessLogic)
        let window = NSWindow(width: 350, height: 212, title: "Transaction Details")
        self.window = window
        window.contentView = NSHostingView(rootView: self)
        window.makeKeyAndOrderFront(nil)
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
