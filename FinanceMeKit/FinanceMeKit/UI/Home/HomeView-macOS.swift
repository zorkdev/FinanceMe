import SwiftUI

public struct HomeView: View {
    private let appState: AppState
    private let loadingState = LoadingState()
    @ObservedObject private var viewModel: HomeViewModel

    public var body: some View {
        VStack(spacing: .zero) {
            HomeNavigationBarView(appState: appState, loadingState: loadingState)
            TodayView(appState: appState)
            TabView {
                FeedView(appState: appState, loadingState: loadingState)
                    .tabItem {
                        Text("Feed")
                    }
                    .tag(0)
                RegularsView(appState: appState, loadingState: loadingState)
                    .tabItem {
                        Text("Regulars")
                    }
                    .tag(1)
                BalancesView(appState: appState)
                    .tabItem {
                        Text("Balances")
                    }
                    .tag(2)
            }
            .padding()
        }
        .onAppear(perform: viewModel.onAppear)
    }

    public init(appState: AppState) {
        self.appState = appState
        self.viewModel = HomeViewModel(loadingState: loadingState,
                                       userBusinessLogic: appState.userBusinessLogic,
                                       transactionBusinessLogic: appState.transactionBusinessLogic,
                                       summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView(appState: AppState.stub)
    }
}
#endif
