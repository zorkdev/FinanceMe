import WatchKit
import MyFinanceKit

class HomeInterfaceController: WKInterfaceController {

    @IBOutlet private weak var balanceLabel: WKInterfaceLabel!
    @IBOutlet private weak var allowanceLabel: WKInterfaceLabel!
    @IBOutlet private weak var allowanceIconLabel: WKInterfaceLabel!

    private var viewModel: TodayPresentable!

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

        viewModel.updateData()
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
