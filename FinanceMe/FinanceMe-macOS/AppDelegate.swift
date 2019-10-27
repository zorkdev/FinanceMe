import SwiftUI
import FinanceMeKit

// swiftlint:disable unused_declaration
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let appState = AppState()
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        #if DEBUG
        guard isUnitTesting == false else { return }
        #endif

        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                          styleMask: [.titled,
                                      .closable,
                                      .miniaturizable,
                                      .resizable,
                                      .fullSizeContentView],
                          backing: .buffered,
                          defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: RootView(appState: appState))
        window.makeKeyAndOrderFront(nil)
    }
}
