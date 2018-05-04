class AddTransactionViewController: BaseViewController, KeyboardManageable, TableViewContainer {

    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet private weak var saveButton: UIButton!

    private var viewModel: AddTransactionViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveButtonTapped()
    }

    @IBAction func dismissTapped(_ sender: UIButton) {
        viewModel.dismissTapped()
    }

}

extension AddTransactionViewController: ViewModelInjectable {

    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? AddTransactionViewModelType else { return }
        self.viewModel = viewModel
    }

}

extension AddTransactionViewController: AddTransactionViewModelDelegate {

    func updateSaveButton(enabled: Bool) {
        saveButton.isEnabled = enabled

        UIView.animate(withDuration: AddTransactionDisplayModel.buttonAnimationDuration) {
            self.saveButton.alpha = enabled ? AddTransactionDisplayModel.buttonEnabledAlpha :
                                              AddTransactionDisplayModel.buttonDisabledAlpha
        }
    }

}
