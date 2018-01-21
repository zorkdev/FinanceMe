class HomeViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var allowanceLabel: UILabel!

    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        viewModel.viewDidLoad()
    }

}

extension HomeViewController: HomeViewModelDelegate {

    func set(balance: String) {
        balanceLabel.text = balance
    }

    func set(allowance: String) {
        allowanceLabel.text = allowance
    }

}
