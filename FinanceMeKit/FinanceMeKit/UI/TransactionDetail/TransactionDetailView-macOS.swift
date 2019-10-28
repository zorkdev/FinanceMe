import SwiftUI

public struct TransactionDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: TransactionDetailViewModel

    public var body: some View {
        Form {
            VStack(alignment: .leading) {
                HStack {
                    Text("Amount")
                    TextField("£0.00", text: $viewModel.amount, onEditingChanged: viewModel.onAmountEditingChanged)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Description")
                    TextField("Groceries", text: $viewModel.narrative)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Category", selection: $viewModel.category) {
                    ForEach(Transaction.Source.allCases, id: \.self) { Text($0.displayString) }
                }
                DatePicker("Date", selection: $viewModel.date)
                HStack {
                    Button("Cancel") { self.presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    Button("Save", action: self.viewModel.onSave)
                        .disabled(viewModel.isDisabled)
                }
            }
        }
        .padding()
        .frame(idealWidth: 300)
    }

    public init(transaction: Transaction?, appState: AppState) {
        self.viewModel = TransactionDetailViewModel(transaction: transaction,
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
            .previewLayout(.sizeThatFits)
    }
}
#endif
