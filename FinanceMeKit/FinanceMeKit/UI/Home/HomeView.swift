import SwiftUI

struct HomeView: View {
    private let appState: AppState

    var body: some View {
        TodayView(appState: appState)
    }

    init(appState: AppState) {
        self.appState = appState
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
