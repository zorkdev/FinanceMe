class HomeViewController: BaseViewController {
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var allowanceLabel: UILabel!
    @IBOutlet private var allowanceIconLabel: UILabel!

    @IBOutlet private var feedUITableView: UITableView!
    @IBOutlet private var regularsUITableView: UITableView!
    @IBOutlet private var balancesUITableView: UITableView!

    @IBOutlet private var transactionsButton: UIButton!
    @IBOutlet private var regularsButton: UIButton!
    @IBOutlet private var balanceButton: UIButton!

    @IBOutlet private var tabIndicator: UIView!
    @IBOutlet private var scrollView: UIScrollView!

    var viewModel: HomeViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    @IBAction private func transactionsButtonTapped(_ sender: UIButton) {
        let offset = feedUITableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction private func regularsButtonTapped(_ sender: UIButton) {
        let offset = regularsUITableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction private func balanceButtonTapped(_ sender: UIButton) {
        let offset = balancesUITableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        viewModel.settingsButtonTapped()
    }

    @IBAction func addTransactionButtonTapped(_ sender: UIButton) {
        viewModel.addTransactionButtonTapped()
    }
}

extension HomeViewController: ViewModelInjectable {
    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? HomeViewModelType else { return }
        self.viewModel = viewModel
    }
}

extension HomeViewController: HomeViewModelDelegate {
    var feedTableView: TableViewType! { return feedUITableView }
    var regularsTableView: TableViewType! { return regularsUITableView }
    var balancesTableView: TableViewType! { return balancesUITableView }

    func set(balance: NSAttributedString) {
        balanceLabel.attributedText = balance
    }

    func set(allowance: NSAttributedString) {
        allowanceLabel.attributedText = allowance
    }

    func set(allowanceIcon: String) {
        allowanceIconLabel.text = allowanceIcon
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
        let offsetRatio = scrollView.contentOffset.x / balancesUITableView.frame.origin.x
        let maxX = balanceButton.frame.origin.x
        let newX = offsetRatio * maxX

        let newFrame = CGRect(x: newX,
                              y: tabIndicator.frame.origin.y,
                              width: tabIndicator.frame.width,
                              height: tabIndicator.frame.height)
        tabIndicator.frame = newFrame
    }
}
