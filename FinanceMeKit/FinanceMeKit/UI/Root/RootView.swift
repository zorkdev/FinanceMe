import SwiftUI

public struct RootView: View {
    private let appState: AppState
    @ObservedObject private var viewModel: RootViewModel

    public var body: some View {
        Group {
            if viewModel.isLoggedIn {
                HomeView(appState: appState)
            } else {
                LoginView(appState: appState)
            }
        }
    }

    public init(appState: AppState) {
        self.appState = appState
        self.viewModel = RootViewModel(service: appState.sessionService, businessLogic: appState.sessionBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct RootViewPreviews: PreviewProvider {
    static var previews: some View {
        RootView(appState: AppState.stub)
    }
}
#endif
