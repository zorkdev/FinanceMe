import SwiftUI

struct LoadingView<Presenting: View>: View {
    private let presenting: Presenting
    @ObservedObject private var loadingState: LoadingState

    var body: some View {
        ZStack {
            presenting
                .blur(radius: loadingState.isLoading ? 4 : .zero)
                .disabled(loadingState.isLoading)

            if loadingState.isLoading {
                VStack {
                    ActivityIndicatorView(style: .large)
                    Text("Doing some magic... 😬")
                }
            }
        }
        .animation(.easeInOut)
    }

    init(_ loadingState: LoadingState, presenting: Presenting) {
        self.loadingState = loadingState
        self.presenting = presenting
    }
}

extension View {
    func loading(_ loadingState: LoadingState) -> some View {
        LoadingView(loadingState, presenting: self)
    }
}
