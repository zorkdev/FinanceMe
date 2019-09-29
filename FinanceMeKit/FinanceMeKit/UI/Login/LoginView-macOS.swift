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
                    Button(action: viewModel.onTap) {
                        Text("Login")
                    }
                    .disabled(viewModel.isDisabled)
                }
            }
            .padding()
        }
    }

    public init(appState: AppState) {
        self.viewModel = LoginViewModel(businessLogic: appState.sessionBusinessLogic)
    }
}

struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
