import SwiftUI

public struct TransactionNavigationView: View {
    private let appState: AppState
    private let transaction: Transaction
    @State private var isDetailPresented = false

    public var body: some View {
        TransactionView(viewModel: TransactionViewModel(narrative: transaction.narrative,
                                                        amount: transaction.amount))
            .onTapGesture { self.isDetailPresented = true }
            .sheet(isPresented: self.$isDetailPresented) {
                TransactionDetailView(transaction: self.transaction, appState: self.appState)
            }
    }

    init(transaction: Transaction, appState: AppState) {
        self.appState = appState
        self.transaction = transaction
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct TransactionNavigationViewPreviews: PreviewProvider {
    static var previews: some View {
        TransactionNavigationView(transaction: Transaction(id: UUID(),
                                                           amount: -113.76,
                                                           direction: .outbound,
                                                           created: Date(),
                                                           narrative: "Groceries",
                                                           source: .externalOutbound),
                                  appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
