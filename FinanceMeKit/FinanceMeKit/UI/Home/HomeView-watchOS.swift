import SwiftUI

public struct HomeView: View {
    @ObservedObject private var appState: AppState

    public var body: some View {
        TodayView(appState: appState)
    }

    public init(appState: AppState) {
        self.appState = appState
    }
}

#if DEBUG
struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView(appState: AppState.stub)
    }
}
#endif
