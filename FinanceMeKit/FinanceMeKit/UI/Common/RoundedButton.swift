import SwiftUI

public struct RoundedButton: View {
    private let title: String
    private let action: () -> Void

    public var body: some View {
        Button(action: self.action) {
            Text(self.title)
                .foregroundColor(Color.white)
                .bold()
        }
        .padding()
        .frame(width: min(UIScreen.main.bounds.width - 32, 500))
        .background(Color(.link))
        .cornerRadius(12)
        .padding([.leading, .trailing])
    }

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct RoundedButtonPreviews: PreviewProvider {
    static var previews: some View {
        RoundedButton("Button", action: action)
    }
    static func action() {}
}
#endif
