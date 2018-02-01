class HomeViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var allowanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: HomeViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        viewModel.viewDidLoad()
    }

}

extension HomeViewController: HomeViewModelDelegate {

    func set(balance: NSAttributedString) {
        balanceLabel.attributedText = balance
    }

    func set(allowance: NSAttributedString) {
        allowanceLabel.attributedText = allowance
    }

    func reloadTableView() {
        tableView.reloadData()
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.externalTransactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        let transaction = viewModel.externalTransactions[indexPath.row]
        cell.textLabel?.text = transaction.narrative
        cell.detailTextLabel?.text = Formatters.currencyPlusSign.string(from: NSNumber(value: transaction.amount))

        return cell
    }

}
