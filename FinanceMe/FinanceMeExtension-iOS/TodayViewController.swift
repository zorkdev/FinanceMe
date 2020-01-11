import SwiftUI
import NotificationCenter
import FinanceMeKit

// swiftlint:disable unused_declaration
class TodayViewController: UIHostingController<AnyView>, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: AnyView(TodayView(appState: appState)))
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }

    required init?(coder aDecoder: NSCoder) { nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }

    @objc
    private func onTap() {
        extensionContext?.open(Link.urlScheme, completionHandler: nil)
    }
}
