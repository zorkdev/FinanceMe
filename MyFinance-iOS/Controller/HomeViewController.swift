class HomeViewController: BaseViewController {

    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var allowanceLabel: UILabel!
    @IBOutlet private weak var transactionsTableView: UITableView!
    @IBOutlet private weak var regularsTableView: UITableView!
    @IBOutlet private weak var balanceTableView: UITableView!
    @IBOutlet private weak var transactionsButton: UIButton!
    @IBOutlet private weak var regularsButton: UIButton!
    @IBOutlet private weak var balanceButton: UIButton!
    @IBOutlet private weak var tabIndicator: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!

    private var viewModel: HomeViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        viewModel.viewDidLoad()
    }

    @IBAction func transactionsButtonTapped(_ sender: UIButton) {
        let offset = transactionsTableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction func regularsButtonTapped(_ sender: UIButton) {
        let offset = regularsTableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction func balanceButtonTapped(_ sender: UIButton) {
        let offset = balanceTableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addTransactionViewController = segue.destination as? AddTransactionViewController else { return }
        addTransactionViewController.dataDelegate = viewModel
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
        transactionsTableView.reloadData()
        regularsTableView.reloadData()
        balanceTableView.reloadData()
    }

    func delete(from tab: HomeViewModel.Tab, section: Int) {
        let indexSet = IndexSet(integer: section)

        switch tab {
        case .transactions:
            transactionsTableView.deleteSections(indexSet, with: .automatic)
        case .bills:
            regularsTableView.deleteSections(indexSet, with: .automatic)
        case .balances:
            return
        }
    }

    func delete(from tab: HomeViewModel.Tab, section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)

        switch tab {
        case .transactions:
            transactionsTableView.deleteRows(at: [indexPath], with: .automatic)
        case .bills:
            regularsTableView.deleteRows(at: [indexPath], with: .automatic)
        case .balances:
            return
        }
    }

    func showAlert(with title: String,
                   message: String,
                   confirmActionTitle: String,
                   confirmAction: @escaping () -> Void,
                   cancelActionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .destructive) { _ in
            confirmAction()
        }
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let offsetRatio = scrollView.contentOffset.x / balanceTableView.frame.origin.x
        let maxX = balanceButton.frame.origin.x
        let newX = offsetRatio * maxX

        let newFrame = CGRect(x: newX,
                              y: tabIndicator.frame.origin.y,
                              width: tabIndicator.frame.width,
                              height: tabIndicator.frame.height)
        tabIndicator.frame = newFrame
    }

}

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case transactionsTableView:
            return viewModel.numberOfSections(in: .transactions)
        case regularsTableView:
            return viewModel.numberOfSections(in: .bills)
        case balanceTableView:
            return viewModel.numberOfSections(in: .balances)
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tab: HomeViewModel.Tab
        switch tableView {
        case transactionsTableView:
            tab = .transactions
        case regularsTableView:
            tab = .bills
        case balanceTableView:
            tab = .balances
        default: return 0
        }

        return viewModel.numberOfRows(in: tab, in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.string, for: indexPath)

        let tab: HomeViewModel.Tab
        switch tableView {
        case transactionsTableView:
            tab = .transactions
        case regularsTableView:
            tab = .bills
        case balanceTableView:
            tab = .balances
        default: return cell
        }

        guard let cellModel = viewModel.cellModel(for: tab,
                                        section: indexPath.section,
                                        row: indexPath.row) else { return cell }
        cell.set(homeCellModel: cellModel)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tab: HomeViewModel.Tab
        switch tableView {
        case transactionsTableView:
            tab = .transactions
        case regularsTableView:
            tab = .bills
        case balanceTableView:
            tab = .balances
        default: return nil
        }

        return viewModel.header(for: tab, section: section)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableView {
        case transactionsTableView, regularsTableView: return true
        default: return false
        }
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let tab: HomeViewModel.Tab
        switch tableView {
        case transactionsTableView:
            tab = .transactions
        case regularsTableView:
            tab = .bills
        default: return
        }

        viewModel.delete(from: tab,
                         section: indexPath.section,
                         row: indexPath.row)
    }

}
