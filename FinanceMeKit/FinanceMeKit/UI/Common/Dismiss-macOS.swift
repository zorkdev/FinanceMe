import SwiftUI

struct Dismiss<Presenting: View>: View {
    private let presenting: Presenting
    private weak var window: NSWindow?
    @Binding private var shouldDismiss: Bool

    var body: some View {
        Group {
            presenting

            if shouldDismiss {
                Spacer()
                    .frame(width: .zero, height: .zero)
                    .onAppear { self.window?.close() }
            }
        }
    }

    init(_ shouldDismiss: Binding<Bool>, window: NSWindow?, presenting: Presenting) {
        self._shouldDismiss = shouldDismiss
        self.window = window
        self.presenting = presenting
    }
}

extension View {
    func dismiss(shouldDismiss: Binding<Bool>, window: NSWindow?) -> some View {
        Dismiss(shouldDismiss, window: window, presenting: self)
    }
}
