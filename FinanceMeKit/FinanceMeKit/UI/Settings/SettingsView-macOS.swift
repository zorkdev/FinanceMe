import SwiftUI

public struct SettingsView: View {
    @ObservedObject private var viewModel: SettingsViewModel

    public var body: some View {
        NavigationView {
            Button("Reconcile", action: viewModel.onReconcile)
        }
    }

    public init(appState: AppState) {
        self.viewModel = SettingsViewModel(userBusinessLogic: appState.userBusinessLogic,
                                           transactionBusinessLogic: appState.transactionBusinessLogic,
                                           summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
