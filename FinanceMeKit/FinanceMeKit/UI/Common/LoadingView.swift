import SwiftUI

public struct LoadingView<Presenting: View>: View {
    private let presenting: Presenting
    @Binding private var isLoading: Bool

    public var body: some View {
        ZStack {
            presenting
                .blur(radius: isLoading ? 4 : 0)
                .disabled(isLoading)

            if isLoading {
                VStack {
                    ActivityIndicatorView()
                    Text("Doing some magic... 😬")
                }
            }
        }
        .animation(.easeInOut)
    }

    public init(_ isLoading: Binding<Bool>, presenting: Presenting) {
        self._isLoading = isLoading
        self.presenting = presenting
    }
}

public extension View {
    func loading(isLoading: Binding<Bool>) -> some View {
        LoadingView(isLoading, presenting: self)
    }
}
