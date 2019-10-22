import SwiftUI

public struct HomeView: View {
    @ObservedObject private var appState: AppState
    @ObservedObject private var viewModel: HomeViewModel

    public var body: some View {
        VStack {
            TodayView(appState: appState)
                .padding([.top])
            FeedView(appState: appState)
        }
        .onAppear(perform: viewModel.onAppear)
    }

    public init(appState: AppState) {
        self.appState = appState
        self.viewModel = HomeViewModel(transactionBusinessLogic: appState.transactionBusinessLogic,
                                       summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView(appState: AppState.stub)
    }
}
#endif
