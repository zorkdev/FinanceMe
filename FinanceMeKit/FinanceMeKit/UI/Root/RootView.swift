import SwiftUI

public struct RootView: View {
    @ObservedObject private var appState: AppState
    @ObservedObject private var viewModel: RootViewModel

    public var body: some View {
        Group {
            if viewModel.isLoggedIn {
                TodayView(appState: appState)
            } else {
                LoginView(appState: appState)
            }
        }
    }

    public init(appState: AppState) {
        self.appState = appState
        self.viewModel = RootViewModel(businessLogic: appState.sessionBusinessLogic)
    }
}

struct RootViewPreviews: PreviewProvider {
    static var previews: some View {
        RootView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
