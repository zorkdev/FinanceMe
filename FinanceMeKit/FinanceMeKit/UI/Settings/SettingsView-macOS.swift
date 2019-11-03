import SwiftUI

public struct SettingsView: View {
    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: SettingsViewModel

    public var body: some View {
        Form {
            VStack {
                HStack {
                    Text("Name")
                    TextField("Your Name", text: $viewModel.name)
                }
                HStack {
                    Text("Amount Limit")
                    TextField("£0.00", text: $viewModel.limit, onEditingChanged: viewModel.onLimitEditingChanged)
                }
                Picker("Payday", selection: $viewModel.payday) {
                    ForEach(viewModel.paydays, id: \.self) { Text("\($0)") }
                }
                DatePicker("Start Date",
                           selection: $viewModel.date,
                           in: ...Date(),
                           displayedComponents: [.date])
                HStack {
                    Button("Reconcile", action: viewModel.onReconcile)
                    Button("Log Out", action: viewModel.onLogOut)
                    Spacer()
                    Button("Cancel") { self.presentationMode.wrappedValue.dismiss() }
                    Button("Save", action: self.viewModel.onSave)
                        .disabled(viewModel.isDisabled)
                }
            }
        }
        .padding()
        .frame(idealWidth: 350)
        .loading(loadingState)
        .errorBanner(errorViewModel)
        .dismiss(shouldDismiss: $viewModel.shouldDismiss)
    }

    public init(appState: AppState) {
        self.viewModel = SettingsViewModel(sessionBusinessLogic: appState.sessionBusinessLogic,
                                           userBusinessLogic: appState.userBusinessLogic,
                                           transactionBusinessLogic: appState.transactionBusinessLogic,
                                           summaryBusinessLogic: appState.summaryBusinessLogic,
                                           loadingState: loadingState,
                                           errorViewModel: errorViewModel)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView(appState: AppState.stub)
    }
}
#endif
