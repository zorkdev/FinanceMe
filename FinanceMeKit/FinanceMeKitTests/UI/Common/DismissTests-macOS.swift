import XCTest
import SwiftUI
@testable import FinanceMeKit

final class DismissTests: XCTestCase {
    struct DismissingTestView: View {
        @State var shouldDismiss = true
        weak var window: NSWindow?

        var body: some View {
            Spacer().dismiss(shouldDismiss: $shouldDismiss, window: window)
        }

        init() {
            let window = NSWindow(width: 350, height: 212, title: "Preferences")
            self.window = window
            window.contentView = NSHostingView(rootView: self)
            window.makeKeyAndOrderFront(nil)
        }
    }

    struct TestView: View {
        @State var shouldDismiss = false
        weak var window: NSWindow?

        var body: some View {
            Spacer().dismiss(shouldDismiss: $shouldDismiss, window: window)
        }

        init() {
            let window = NSWindow(width: 350, height: 212, title: "Preferences")
            self.window = window
            window.contentView = NSHostingView(rootView: self)
            window.makeKeyAndOrderFront(nil)
        }
    }

    func testView() {
        assert(view: DismissingTestView())
        assert(view: TestView())
    }
}
