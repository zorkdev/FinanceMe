import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    private let style: Style

    init(style: Style) {
        self.style = style
    }

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style.uiStyle)
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

extension ActivityIndicatorView.Style {
    var uiStyle: UIActivityIndicatorView.Style {
        switch self {
        case .medium: return .medium
        case .large: return .large
        }
    }
}
