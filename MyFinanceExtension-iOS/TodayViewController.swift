import NotificationCenter

class TodayViewController: BaseViewController {

    @IBOutlet private weak var primaryVibrancyEffectView: UIVisualEffectView!
    @IBOutlet private weak var secondaryVibrancyEffectView: UIVisualEffectView!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var allowanceLabel: UILabel!

    private var viewModel: TodayViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        primaryVibrancyEffectView.effect = UIVibrancyEffect.widgetPrimary()
        secondaryVibrancyEffectView.effect = UIVibrancyEffect.widgetSecondary()
        viewModel = TodayViewModel(delegate: self, displayModel: TodayDisplayModel())
        viewModel.viewDidLoad()
    }

}

extension TodayViewController: TodayViewModelDelegate {

    func set(balance: NSAttributedString) {
        balanceLabel.attributedText = balance
    }

    func set(allowance: NSAttributedString) {
        allowanceLabel.attributedText = allowance
    }

}

extension TodayViewController: NCWidgetProviding {

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel.updateData().then {
            completionHandler(.newData)
        }.catch { error in
            print(error)
            completionHandler(.failed)
        }
    }

}
