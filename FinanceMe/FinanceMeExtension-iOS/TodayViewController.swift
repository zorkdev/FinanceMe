import UIKit
import NotificationCenter
import FinanceMeKit

class TodayViewController: UIViewController, NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(AmountViewModel(value: Decimal(string: "10")!).string)
        completionHandler(NCUpdateResult.newData)
    }
}
