import SwiftUI
import FinanceMeKit

class HostingController: WKHostingController<AnyView> {
    private let appState = (WKExtension.shared().delegate as? ExtensionDelegate)!.appState

    override var body: AnyView {
        AnyView(RootView(appState: appState))
    }
}
