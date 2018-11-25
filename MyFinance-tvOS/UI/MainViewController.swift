class MainViewController: BaseViewController {

    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var allowanceLabel: UILabel!
    @IBOutlet private weak var allowanceIconLabel: UILabel!

    let appState = AppState()

    var viewModel: TodayPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TodayViewModel(serviceProvider: appState,
                                   displayModel: MainDisplayModel())
        viewModel.inject(delegate: self)
        viewModel.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        update()
    }

    @objc func update() {
        viewModel.updateData()
    }

}

extension MainViewController: TodayViewModelDelegate {

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
