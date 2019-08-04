import Cocoa
import SwiftUI
import FinanceMeKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
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
        window.contentView = NSHostingView(rootView: ContentView())
        window.makeKeyAndOrderFront(nil)
    }
}
