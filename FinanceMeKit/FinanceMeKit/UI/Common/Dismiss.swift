import SwiftUI

public struct Dismiss: View {
    @Binding private var shouldDismiss: Bool
    @Binding private var presentationMode: PresentationMode

    public var body: some View {
        Group {
            if shouldDismiss {
                Spacer()
                    .frame(width: .zero, height: .zero)
                    .onAppear { self.presentationMode.dismiss() }
            } else {
                EmptyView()
            }
        }
    }

    public init(_ shouldDismiss: Binding<Bool>, presentationMode: Binding<PresentationMode>) {
        self._shouldDismiss = shouldDismiss
        self._presentationMode = presentationMode
    }
}
