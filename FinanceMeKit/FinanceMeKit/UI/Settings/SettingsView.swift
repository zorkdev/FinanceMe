import SwiftUI

public struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: SettingsViewModel

    public var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Name")
                            TextField("Your Name", text: $viewModel.name)
                                .autocapitalization(.words)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Amount Limit")
                            TextField("£0.00",
                                      text: $viewModel.limit,
                                      onEditingChanged: viewModel.onLimitEditingChanged)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        Picker("Payday", selection: $viewModel.payday) {
                            ForEach(viewModel.paydays, id: \.self) { Text("\($0)") }
                        }
                        DatePicker("Start Date",
                                   selection: $viewModel.date,
                                   in: ...Date(),
                                   displayedComponents: [.date])
                    }
                    .disabled(!viewModel.isEditing)
                }
                Spacer()
                RoundedButton("Reconcile", action: viewModel.onReconcile)
                    .padding([.bottom], 8)
                Button(action: viewModel.onLogOut) {
                    Text("Log Out")
                        .bold()
                        .padding()
                }
                Dismiss($viewModel.shouldDismiss, presentationMode: presentationMode)
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(leading: Button(viewModel.isEditing ? "Cancel" : "Edit") {
                self.viewModel.isEditing.toggle()
            }, trailing: Button(viewModel.isEditing ? "Save" : "Done") {
                self.viewModel.isEditing ? self.viewModel.onSave() : self.presentationMode.wrappedValue.dismiss()
            }.disabled(viewModel.isEditing ? viewModel.isDisabled : false))
        }
    }

    public init(appState: AppState) {
        self.viewModel = SettingsViewModel(sessionBusinessLogic: appState.sessionBusinessLogic,
                                           userBusinessLogic: appState.userBusinessLogic,
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