import SwiftUI

struct AuthenticationView: View {
    @ObservedObject private var viewModel: AuthenticationViewModel

    var body: some View {
        Group {
            if viewModel.isAuthenticated == false {
                VStack(spacing: 32) {
                    Button(action: viewModel.onAppear) {
                        Image(systemName: "faceid").font(.system(size: 60))
                    }
                    Text("Please authenticate").font(.title).bold()
                }
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                .background(Color(.systemBackground))
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: viewModel.onAppear)
            }
        }
    }

    init(appState: AppState) {
        self.viewModel = AuthenticationViewModel(businessLogic: appState.authenticationBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct AuthenticationViewPreviews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(appState: AppState.stub)
    }
}
#endif
