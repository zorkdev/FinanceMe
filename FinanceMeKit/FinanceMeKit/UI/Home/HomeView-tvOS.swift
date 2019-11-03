import SwiftUI

struct HomeView: View {
    private let appState: AppState
    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
    @ObservedObject private var viewModel: HomeViewModel

    var body: some View {
        TodayView(appState: appState)
            .onAppear(perform: viewModel.onAppear)
    }

    init(appState: AppState) {
        self.appState = appState
        self.viewModel = HomeViewModel(loadingState: loadingState,
                                       errorViewModel: errorViewModel,
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
