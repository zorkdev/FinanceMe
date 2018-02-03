class HomeViewController: UIViewController {

    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var allowanceLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private var viewModel: HomeViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        viewModel.viewDidLoad()
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.segmentedControlValueChanged(value: sender.selectedSegmentIndex)
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

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.string, for: indexPath)
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.set(homeCellModel: cellModel)

        return cell
    }

}
