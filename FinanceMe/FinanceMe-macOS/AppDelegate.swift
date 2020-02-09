import AppKit
import FinanceMeKit

// swiftlint:disable unused_declaration
@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let appState = AppState()

    @IBOutlet private var preferencesMenuItem: NSMenuItem!
    @IBOutlet private var newTransactionMenuItem: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        #if DEBUG
        guard isUnitTesting == false else { return }
        #endif

        _ = RootController(application: NSApplication.shared,
                           appState: appState,
                           preferencesMenuItem: preferencesMenuItem,
                           newTransactionMenuItem: newTransactionMenuItem)
    }
}
