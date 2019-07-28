import Cocoa
import NotificationCenter
import FinanceMeKit

class TodayViewController: NSViewController, NCWidgetProviding {
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(Content.content)
        completionHandler(.noData)
    }
}
