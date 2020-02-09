import SwiftUI

struct LoadingView: View {
    @ObservedObject private var loadingState: LoadingState

    var body: some View {
        Group {
            if loadingState.isLoading {
                ActivityIndicatorView(style: .medium)
            }
        }
    }

    init(_ loadingState: LoadingState) {
        self.loadingState = loadingState
    }
}
