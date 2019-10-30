import SwiftUI

public struct HomeView: View {
    private let appState: AppState
    @ObservedObject private var viewModel: HomeViewModel

    public var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                HomeNavigationBarView(appState: appState)
                TodayView(appState: appState)
                    .padding([.top, .bottom])
                Divider()
                TabView {
                    FeedView(appState: appState)
                        .tabItem {
                            Image(systemName: "tray.full.fill")
                            Text("Feed")
                        }
                        .tag(0)
                    RegularsView(appState: appState)
                        .tabItem {
                            Image(systemName: "arrow.2.circlepath.circle.fill")
                            Text("Regulars")
                        }
                        .tag(1)
                    BalancesView(appState: appState)
                        .tabItem {
                            Image(systemName: "doc.text.fill")
                            Text("Balances")
                        }
                        .tag(2)
                }
            }
            .onAppear(perform: viewModel.onAppear)

            AuthenticationView(appState: appState)
        }
    }

    public init(appState: AppState) {
        self.appState = appState
        self.viewModel = HomeViewModel(userBusinessLogic: appState.userBusinessLogic,
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
