import UIKit
import SwiftUI
import NotificationCenter
import FinanceMeKit

class TodayViewController: UIHostingController<Text>, NCWidgetProviding {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: Text("£10.00"))
        view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(AmountViewModel(value: Decimal(string: "10")!).string)
        completionHandler(.newData)
    }
}
