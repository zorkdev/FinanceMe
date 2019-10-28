import SwiftUI

public struct FeedView: View {
    @ObservedObject private var viewModel: FeedViewModel
    @State private var isDetailPresented = false

    public var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(header: Text(section.title.uppercased())) {
                    ForEach(section.rows) {
                        TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative,
                                                                        amount: $0.amount))
                            .onTapGesture { self.isDetailPresented = true }
                            .sheet(isPresented: self.$isDetailPresented) { Text("Transaction details") }
                    }
                    .onDelete { self.viewModel.onDelete(section: section, row: $0) }
                }
            }
        }
    }

    public init(appState: AppState) {
        self.viewModel = FeedViewModel(userBusinessLogic: appState.userBusinessLogic,
                                       transactionBusinessLogic: appState.transactionBusinessLogic,
                                       summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct FeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
