import SwiftUI

public struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel

    public var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                    SecureField("Password", text: $viewModel.password)
                }
                Section {
                    Button("Log In", action: viewModel.onTap)
                        .disabled(viewModel.isDisabled)
                }
            }
            .padding()
        }
        .loading(isLoading: $viewModel.isLoading)
    }

    public init(appState: AppState) {
        self.viewModel = LoginViewModel(businessLogic: appState.sessionBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginView(appState: AppState.stub)
    }
}
#endif
