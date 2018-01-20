import NotificationCenter

class TodayViewController: UIViewController {

    @IBOutlet weak var primaryVibrancyEffectView: UIVisualEffectView!
    @IBOutlet weak var secondaryVibrancyEffectView: UIVisualEffectView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!

    var viewModel: TodayViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        primaryVibrancyEffectView.effect = UIVibrancyEffect.widgetPrimary()
        secondaryVibrancyEffectView.effect = UIVibrancyEffect.widgetSecondary()
        viewModel = TodayViewModel(delegate: self)
        viewModel.viewDidLoad()
    }

}

extension TodayViewController: TodayViewModelDelegate {

    func set(balance: String) {
        balanceLabel.text = balance
    }

    func set(spending: String) {
        spendingLabel.text = spending
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
