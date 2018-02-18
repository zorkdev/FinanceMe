class HomeViewController: BaseViewController {

    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var allowanceLabel: UILabel!
    @IBOutlet private weak var allowanceIconLabel: UILabel!
    @IBOutlet private weak var transactionsTableView: UITableView!
    @IBOutlet private weak var regularsTableView: UITableView!
    @IBOutlet private weak var balanceTableView: UITableView!
    @IBOutlet private weak var transactionsButton: UIButton!
    @IBOutlet private weak var regularsButton: UIButton!
    @IBOutlet private weak var balanceButton: UIButton!
    @IBOutlet private weak var tabIndicator: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!

    private var viewModel: HomeViewModelType!

    private let transactionsRefreshControl = UIRefreshControl()
    private let regularsRefreshControl = UIRefreshControl()
    private let balanceRefreshControl = UIRefreshControl()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appState = (UIApplication.shared.delegate as? AppDelegate)?.appState else { return }

        setupTableViews()

        viewModel = HomeViewModel(serviceProvider: appState, delegate: self)
        viewModel.viewDidLoad()
    }

    private func setupTableViews() {
        transactionsTableView.refreshControl = transactionsRefreshControl
        regularsTableView.refreshControl = regularsRefreshControl
        balanceTableView.refreshControl = balanceRefreshControl

        transactionsTableView.contentInset = HomeDisplayModel.tableViewInsets
        regularsTableView.contentInset = HomeDisplayModel.tableViewInsets
        balanceTableView.contentInset = HomeDisplayModel.tableViewInsets

        transactionsRefreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
        regularsRefreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
        balanceRefreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)

        balanceTableView.register(HomeCurrentMonthTableViewCell.nib,
                                  forCellReuseIdentifier: HomeCurrentMonthTableViewCell.instanceName)
        balanceTableView.register(HomeChartTableViewCell.nib,
                                  forCellReuseIdentifier: HomeChartTableViewCell.instanceName)
    }

    private func tab(for tableView: UITableView) -> HomeViewModel.Tab? {
        switch tableView {
        case transactionsTableView: return .transactions
        case regularsTableView: return .bills
        case balanceTableView: return .balances
        default: return nil
        }
    }

    @objc private func updateData(_ sender: UIRefreshControl) {
        viewModel.refreshTapped()
    }

    @IBAction private func transactionsButtonTapped(_ sender: UIButton) {
        let offset = transactionsTableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction private func regularsButtonTapped(_ sender: UIButton) {
        let offset = regularsTableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    @IBAction private func balanceButtonTapped(_ sender: UIButton) {
        let offset = balanceTableView.frame.origin
        scrollView.setContentOffset(offset, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let addTransactionViewController as AddTransactionViewController:
            addTransactionViewController.appState = appState
            addTransactionViewController.dataDelegate = viewModel

        case let settingsViewController as SettingsViewController:
            settingsViewController.appState = appState
            settingsViewController.dataDelegate = viewModel

        default: break
        }
    }

}

extension HomeViewController: HomeViewModelDelegate {

    func set(balance: NSAttributedString) {
        balanceLabel.attributedText = balance
    }

    func set(allowance: NSAttributedString) {
        allowanceLabel.attributedText = allowance
    }

    func set(allowanceIcon: String) {
        allowanceIconLabel.text = allowanceIcon
    }

    func reloadTableView() {
        transactionsTableView.reloadData()
        regularsTableView.reloadData()
        balanceTableView.reloadData()
    }

    func endRefreshing() {
        self.transactionsRefreshControl.endRefreshing()
        self.regularsRefreshControl.endRefreshing()
        self.balanceRefreshControl.endRefreshing()
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let tab = tab(for: tableView) else { return 0 }
        return viewModel.numberOfSections(in: tab)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tab = tab(for: tableView) else { return 0 }
        return viewModel.numberOfRows(in: tab, in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tab = tab(for: tableView) else { return UITableViewCell() }

        guard let cellModel = viewModel.cellModel(for: tab,
                                                  section: indexPath.section,
                                                  row: indexPath.row) else { return UITableViewCell() }

        switch cellModel {
        case let homeCellModel as HomeCellModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.instanceName,
                                                           for: indexPath)
                as? HomeTableViewCell else { return UITableViewCell() }
            cell.set(homeCellModel: homeCellModel)
            return cell

        case let homeCurrentMonthCellModel as HomeCurrentMonthCellModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCurrentMonthTableViewCell.instanceName,
                                                           for: indexPath)
                as? HomeCurrentMonthTableViewCell else { return UITableViewCell() }
            cell.set(homeCurrentMonthCellModel: homeCurrentMonthCellModel)
            return cell

        case let homeChartCellModel as HomeChartCellModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChartTableViewCell.instanceName,
                                                           for: indexPath)
                as? HomeChartTableViewCell else { return UITableViewCell() }
            cell.set(homeChartCellModel: homeChartCellModel)
            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tab = tab(for: tableView) else { return nil }
        return viewModel.header(for: tab, section: section)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let tab = tab(for: tableView) else { return false }
        return viewModel.canEdit(tab: tab, section: indexPath.section, row: indexPath.row)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
            let tab = tab(for: tableView) else { return  }

        viewModel.delete(from: tab,
                         section: indexPath.section,
                         row: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tab = tab(for: tableView) else { return UITableViewAutomaticDimension }
        return viewModel.height(for: tab, section: indexPath.section, row: indexPath.row)
    }

}
