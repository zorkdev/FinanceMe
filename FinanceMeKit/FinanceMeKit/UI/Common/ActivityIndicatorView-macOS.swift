import SwiftUI

struct ActivityIndicatorView: NSViewRepresentable {
    private let style: Style

    init(style: Style) {
        self.style = style
    }

    func makeNSView(context: Context) -> NSProgressIndicator {
        let view = NSProgressIndicator()
        view.style = .spinning
        view.controlSize = style.controlSize
        view.startAnimation(nil)
        return view
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {}
}

extension ActivityIndicatorView.Style {
    var controlSize: NSControl.ControlSize {
        switch self {
        case .medium: return .small
        case .large: return .regular
        }
    }
}
