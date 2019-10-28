import SwiftUI

public struct FeedView: View {
    private let appState: AppState
    @ObservedObject private var viewModel: FeedViewModel

    public var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(header: Text(section.title.uppercased())) {
                    ForEach(section.rows) {
                        TransactionNavigationView(transaction: $0, appState: self.appState)
                    }
                    .onDelete { self.viewModel.onDelete(section: section, row: $0) }
                }
            }
        }
    }

    public init(appState: AppState) {
        self.appState = appState
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
