import SwiftUI
import FinanceMeKit

// swiftlint:disable unused_declaration
class HostingController: WKHostingController<AnyView> {
    private let appState = (WKExtension.shared().delegate as? ExtensionDelegate)!.appState

    override var body: AnyView {
        AnyView(RootView(appState: appState))
    }
}
