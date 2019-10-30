import SwiftUI

public struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel

    public var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                }
                Section {
                    Button("Log In", action: viewModel.onTap)
                        .disabled(viewModel.isDisabled)
                }
            }
            .navigationBarTitle("Login")
        }
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
