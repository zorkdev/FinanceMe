import SwiftUI

struct Dismiss<Presenting: View>: View {
    private let presenting: Presenting
    @Environment(\.presentationMode) private var presentationMode
    @Binding private var shouldDismiss: Bool

    var body: some View {
        Group {
            presenting

            if shouldDismiss {
                Spacer()
                    .frame(width: .zero, height: .zero)
                    .onAppear { self.presentationMode.wrappedValue.dismiss() }
            }
        }
    }

    init(_ shouldDismiss: Binding<Bool>, presenting: Presenting) {
        self._shouldDismiss = shouldDismiss
        self.presenting = presenting
    }
}

extension View {
    func dismiss(shouldDismiss: Binding<Bool>) -> some View {
        Dismiss(shouldDismiss, presenting: self)
    }
}
