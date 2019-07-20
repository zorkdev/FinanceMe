import WatchKit
import MyFinanceKit

class HomeInterfaceController: WKInterfaceController {
    @IBOutlet private var balanceLabel: WKInterfaceLabel!
    @IBOutlet private var allowanceLabel: WKInterfaceLabel!
    @IBOutlet private var allowanceIconLabel: WKInterfaceLabel!

    private var viewModel: HomeViewModelType!

    override init() {
        super.init()

        guard let appState = (WKExtension.shared().delegate as? ExtensionDelegate)?.appState else { return }
        viewModel = HomeViewModel(serviceProvider: appState,
                                  complicationService: appState.complicationService,
                                  displayModel: HomeDisplayModel())
        viewModel.inject(delegate: self)
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        viewModel.setupDefaults()
    }

    override func willActivate() {
        super.willActivate()

        viewModel.update()
    }
}

extension HomeInterfaceController: TodayViewModelDelegate {
    func set(balance: NSAttributedString) {
        balanceLabel.setAttributedText(balance)
    }

    func set(allowance: NSAttributedString) {
        allowanceLabel.setAttributedText(allowance)
    }

    func set(allowanceIcon: String) {
        allowanceIconLabel.setText(allowanceIcon)
    }
}
