import SwiftUI
import NotificationCenter
import FinanceMeKit

// swiftlint:disable unused_declaration
final class TodayViewController: NSViewController, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let todayView = NSHostingView(rootView: TodayView(appState: appState))
        todayView.translatesAutoresizingMaskIntoConstraints = false
        todayView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(onTap)))
        view.addSubview(todayView)

        NSLayoutConstraint.activate([
            todayView.topAnchor.constraint(equalTo: view.topAnchor),
            todayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            todayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8),
            todayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    dynamic required init?(coder: NSCoder) { nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }

    @objc
    private func onTap() {
        NSWorkspace.shared.open(Link.urlScheme)
    }
}
