import SwiftUI

public struct LoadingView<Presenting: View>: View {
    private let presenting: Presenting
    @ObservedObject private var loadingState: LoadingState

    public var body: some View {
        ZStack {
            presenting
                .blur(radius: loadingState.isLoading ? 4 : 0)
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

    public init(_ loadingState: LoadingState, presenting: Presenting) {
        self.loadingState = loadingState
        self.presenting = presenting
    }
}

public extension View {
    func loading(_ loadingState: LoadingState) -> some View {
        LoadingView(loadingState, presenting: self)
    }
}
