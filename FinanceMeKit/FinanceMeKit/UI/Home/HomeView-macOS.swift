import SwiftUI

struct HomeView: View {
    private let appState: AppState
    private let selectionState = SelectionState()
    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
    private let toolbar: HomeToolbar
    @ObservedObject private var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: .zero) {
            TodayView(appState: appState)
                .padding([.top, .bottom])
            Divider()
            HomeTabView(appState: appState,
                        loadingState: loadingState,
                        errorViewModel: errorViewModel,
                        selectionState: selectionState)
        }
        .onAppear(perform: viewModel.onAppear)
        .errorBanner(errorViewModel)
        .frame(minHeight: 600)
    }

    init(appState: AppState) {
        self.appState = appState
        self.viewModel = HomeViewModel(loadingState: loadingState,
                                       errorViewModel: errorViewModel,
                                       userBusinessLogic: appState.userBusinessLogic,
                                       transactionBusinessLogic: appState.transactionBusinessLogic,
                                       summaryBusinessLogic: appState.summaryBusinessLogic)
        self.toolbar = HomeToolbar(appState: appState,
                                   loadingState: loadingState,
                                   errorViewModel: errorViewModel,
                                   selectionState: selectionState)

        let window = NSWindow(width: 700, height: 500, title: "FinanceMe")
        window.titleVisibility = .hidden
        window.setFrameAutosaveName("Main Window")
        window.toolbar = toolbar
        window.contentView = NSHostingView(rootView: self)
        window.makeKeyAndOrderFront(nil)
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
