import SwiftUI

struct HomeTabView: View {
    private let appState: AppState
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    @ObservedObject private var selectionState: SelectionState

    var body: some View {
        Group {
            if selectionState.selectedSegment == 0 {
                FeedView(appState: appState, loadingState: loadingState, errorViewModel: errorViewModel)
            } else if selectionState.selectedSegment == 1 {
                RegularsView(appState: appState, loadingState: loadingState, errorViewModel: errorViewModel)
            } else if selectionState.selectedSegment == 2 {
                BalancesView(appState: appState)
            }
        }
    }

    init(appState: AppState,
         loadingState: LoadingState,
         errorViewModel: ErrorViewModel,
         selectionState: SelectionState) {
        self.appState = appState
        self.loadingState = loadingState
        self.errorViewModel = errorViewModel
        self.selectionState = selectionState
    }
}
