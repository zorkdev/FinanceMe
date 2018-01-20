import UIKit

class BalanceViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!

    var viewModel: BalanceViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BalanceViewModel(delegate: self)
        viewModel.viewDidLoad()
    }

}

extension BalanceViewController: BalanceViewModelDelegate {

    func set(balance: String) {
        balanceLabel.text = balance
    }

}

