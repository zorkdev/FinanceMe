import UIKit
import NotificationCenter
import FinanceMeKit

class TodayViewController: UIViewController, NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(Content.content)
        completionHandler(NCUpdateResult.newData)
    }
}
