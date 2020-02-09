import SwiftUI

struct LoginView: View {
    private let loadingState = LoadingState()
    private let errorViewModel = ErrorViewModel()
    @ObservedObject private var viewModel: LoginViewModel

    var body: some View {
        Form {
            Section {
                TextField("Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
            }
            Section {
                HStack {
                    Spacer()
                    LoadingView(loadingState)
                    Button("Log In", action: viewModel.onTap)
                        .disabled(viewModel.isDisabled)
                }
            }
        }
        .padding()
        .errorBanner(errorViewModel)
    }

    init(appState: AppState) {
        self.viewModel = LoginViewModel(businessLogic: appState.sessionBusinessLogic,
                                        loadingState: loadingState,
                                        errorViewModel: errorViewModel)
        let window = NSWindow(width: 350, height: 133, title: "Login")
        window.contentView = NSHostingView(rootView: self)
        window.makeKeyAndOrderFront(nil)
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
