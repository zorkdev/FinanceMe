import NotificationCenter

class TodayViewController: NSViewController {
    @IBOutlet private var balanceLabel: NSTextField!
    @IBOutlet private var allowanceLabel: NSTextField!
    @IBOutlet private var allowanceIconLabel: NSTextField!

    let appState = AppStatemacOS()

    private var viewModel: TodayPresentable!

    override var nibName: NSNib.Name? {
        return TodayViewController.instanceName
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TodayViewModel(serviceProvider: appState,
                                   displayModel: TodayDisplayModel())
        viewModel.inject(delegate: self)
        viewModel.viewDidLoad()
    }
}

extension TodayViewController: TodayViewModelDelegate {
    func set(balance: NSAttributedString) {
        balanceLabel.attributedStringValue = balance
    }

    func set(allowance: NSAttributedString) {
        let allowanceTemp = NSMutableAttributedString(attributedString: allowance)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        allowanceTemp.addAttributes(
            [.paragraphStyle: paragraphStyle],
            range: NSRange(location: 0, length: allowance.length))
        allowanceLabel.attributedStringValue = allowanceTemp
    }

    func set(allowanceIcon: String) {
        allowanceIconLabel.stringValue = allowanceIcon
    }
}

extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel.updateData().done {
            completionHandler(.newData)
        }.catch { error in
            print(error)
            completionHandler(.failed)
        }
    }
}
