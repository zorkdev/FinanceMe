class HomeViewController: BaseViewController {

    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var allowanceLabel: UILabel!
    @IBOutlet private weak var transactionsTableView: UITableView!
    @IBOutlet private weak var regularsTableView: UITableView!
    @IBOutlet private weak var transactionsButton: UIButton!
    @IBOutlet private weak var regularsButton: UIButton!
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
    }

    func delete(at index: Int, from tab: HomeViewModel.Tab) {
        let indexPath = IndexPath(row: index, section: 0)

        switch tab {
        case .transactions:
            transactionsTableView.deleteRows(at: [indexPath], with: .automatic)
        case .bills:
            regularsTableView.deleteRows(at: [indexPath], with: .automatic)
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
        let offsetRatio = scrollView.contentOffset.x / (scrollView.contentSize.width - regularsTableView.frame.origin.x)
        let maxX = regularsButton.frame.origin.x
        let newX = offsetRatio * maxX

        let newFrame = CGRect(x: newX,
                              y: tabIndicator.frame.origin.y,
                              width: tabIndicator.frame.width,
                              height: tabIndicator.frame.height)
        tabIndicator.frame = newFrame
    }

}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case transactionsTableView:
            return viewModel.normalCellModels.count
        case regularsTableView:
            return viewModel.regularCellModels.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.string, for: indexPath)

        let cellModel: HomeCellModel

        switch tableView {
        case transactionsTableView:
            cellModel = viewModel.normalCellModels[indexPath.row]
        case regularsTableView:
            cellModel = viewModel.regularCellModels[indexPath.row]
        default: return cell
        }

        cell.set(homeCellModel: cellModel)

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        switch tableView {
        case transactionsTableView:
            viewModel.delete(at: indexPath.row, from: .transactions)
        case regularsTableView:
            viewModel.delete(at: indexPath.row, from: .bills)
        default: return
        }
    }

}
