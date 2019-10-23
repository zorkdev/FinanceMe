import SwiftUI

public struct FeedView: View {
    @ObservedObject private var viewModel: FeedViewModel

    public var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(header: Text(section.title.uppercased())) {
                    ForEach(section.rows) {
                        TransactionView(viewModel: TransactionViewModel(narrative: $0.narrative,
                                                                        amount: $0.amount))
                    }
                }
            }
        }
    }

    public init(appState: AppState) {
        self.viewModel = FeedViewModel(businessLogic: appState.transactionBusinessLogic)
    }
}

#if DEBUG
struct FeedViewPreviews: PreviewProvider {
    static var previews: some View {
        FeedView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
