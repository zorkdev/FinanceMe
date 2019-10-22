import Cocoa
import SwiftUI
import NotificationCenter
import FinanceMeKit

class TodayViewController: NSViewController, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let todayView = NSHostingView(rootView: TodayView(appState: appState))
        todayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayView)

        NSLayoutConstraint.activate([
            todayView.topAnchor.constraint(equalTo: view.topAnchor),
            todayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            todayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8),
            todayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    dynamic required init?(coder: NSCoder) { return nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }
}
