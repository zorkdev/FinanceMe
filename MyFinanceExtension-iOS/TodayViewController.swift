import NotificationCenter

class TodayViewController: ViewController {
    @IBOutlet private var primaryVibrancyEffectView: UIVisualEffectView!
    @IBOutlet private var secondaryVibrancyEffectView: UIVisualEffectView!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var allowanceLabel: UILabel!
    @IBOutlet private var allowanceIconLabel: UILabel!

    let appState = AppState()

    private var viewModel: TodayPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryVibrancyEffectView.effect = UIVibrancyEffect.widgetPrimary()
        secondaryVibrancyEffectView.effect = UIVibrancyEffect.widgetSecondary()
        viewModel = TodayViewModel(serviceProvider: appState,
                                   displayModel: TodayDisplayModel())
        viewModel.inject(delegate: self)
        viewModel.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let url = URL(string: appState.configService.urlScheme) else { return }
        extensionContext?.open(url, completionHandler: nil)
    }
}

extension TodayViewController: TodayViewModelDelegate {
    func set(balance: NSAttributedString) {
        balanceLabel.attributedText = balance
    }

    func set(allowance: NSAttributedString) {
        allowanceLabel.attributedText = allowance
    }

    func set(allowanceIcon: String) {
        allowanceIconLabel.text = allowanceIcon
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
