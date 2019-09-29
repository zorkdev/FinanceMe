import UIKit
import SwiftUI
import NotificationCenter
import FinanceMeKit

class TodayViewController: UIHostingController<AnyView>, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: AnyView(TodayView(appState: appState)))
        view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }
}
