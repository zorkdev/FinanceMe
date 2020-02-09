import AppKit

extension NSWindow {
    convenience init(width: CGFloat,
                     height: CGFloat,
                     title: String) {
        self.init(contentRect: NSRect(x: .zero, y: .zero, width: width, height: height),
                  styleMask: [.titled,
                              .closable,
                              .miniaturizable,
                              .resizable,
                              .fullSizeContentView],
                  backing: .buffered,
                  defer: false)
        self.title = title
        isReleasedWhenClosed = false
        tabbingMode = .disallowed
        center()
    }
}
