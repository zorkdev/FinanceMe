import SwiftUI

struct ErrorBannerView<Presenting: View>: View {
    private let presenting: Presenting
    @ObservedObject private var errorViewModel: ErrorViewModel

    var body: some View {
        presenting.alert(isPresented: $errorViewModel.isError) {
            Alert(title: Text("\(errorViewModel.icon!) Uh-oh!"),
                  message: Text(errorViewModel.description!),
                  dismissButton: .default(Text("OK")) { self.errorViewModel.error = nil })
        }
    }

    init(_ errorViewModel: ErrorViewModel, presenting: Presenting) {
        self.errorViewModel = errorViewModel
        self.presenting = presenting
    }
}

extension View {
    func errorBanner(_ errorViewModel: ErrorViewModel) -> some View {
        ErrorBannerView(errorViewModel, presenting: self)
    }
}
