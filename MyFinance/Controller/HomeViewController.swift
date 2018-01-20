class HomeViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!

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

    func set(spending: String) {
        spendingLabel.text = spending
    }

}
