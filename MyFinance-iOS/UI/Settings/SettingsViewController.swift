class SettingsViewController: BaseViewController, KeyboardManageable, TableViewContainer {
    @IBOutlet var uiTableView: UITableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var reconcileButton: UIButton!
    @IBOutlet var saveButton: UIButton!

    var viewModel: SettingsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        reconcileButton.setTitle(viewModel.reconcileButtonTitle, for: .normal)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveButtonTapped()
    }

    @IBAction func reconcileButtonTapped(_ sender: UIButton) {
        viewModel.reconcileButtonTapped()
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        viewModel.editButtonTapped()
    }

    @IBAction func dismissTapped(_ sender: UIButton) {
        viewModel.dismissTapped()
    }
}

extension SettingsViewController: ViewModelInjectable {
    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? SettingsViewModelType else { return }
        self.viewModel = viewModel
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func updateButtons(enabled: Bool, editing: Bool) {
        saveButton.isEnabled = enabled
        reconcileButton.isEnabled = !editing
        saveButton.setTitle(viewModel.saveButtonTitle, for: .normal)
        editButton.setTitle(viewModel.editButtonTitle, for: .normal)

        UIView.animate(withDuration: SettingsDisplayModel.buttonAnimationDuration) {
            self.reconcileButton.alpha = editing ? SettingsDisplayModel.buttonHiddenAlpha :
                SettingsDisplayModel.buttonEnabledAlpha
            self.saveButton.alpha = enabled ? SettingsDisplayModel.buttonEnabledAlpha :
                SettingsDisplayModel.buttonDisabledAlpha
        }
    }
}
