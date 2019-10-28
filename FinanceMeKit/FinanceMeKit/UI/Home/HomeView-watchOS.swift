import SwiftUI

public struct HomeView: View {
    private let appState: AppState

    public var body: some View {
        TodayView(appState: appState)
    }

    public init(appState: AppState) {
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
