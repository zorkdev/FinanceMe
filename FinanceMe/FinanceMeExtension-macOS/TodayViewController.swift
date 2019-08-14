import Cocoa
import NotificationCenter
import FinanceMeKit

class TodayViewController: NSViewController, NCWidgetProviding {
    override var nibName: NSNib.Name? { NSNib.Name(Self.instanceName) }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(AmountViewModel(value: Decimal(string: "10")!).string)
        completionHandler(.newData)
    }
}
