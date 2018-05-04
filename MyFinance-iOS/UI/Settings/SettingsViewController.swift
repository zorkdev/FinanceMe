class SettingsViewController: BaseViewController, KeyboardManageable, TableViewContainer {

    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    var viewModel: SettingsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveButtonTapped()
    }

    @IBAction private func editButtonTapped(_ sender: UIButton) {
        viewModel.editButtonTapped()
    }

    @IBAction private func dismissTapped(_ sender: UIButton) {
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
        saveButton.setTitle(viewModel.saveButtonTitle, for: .normal)
        editButton.setTitle(viewModel.editButtonTitle, for: .normal)

        UIView.animate(withDuration: SettingsDisplayModel.buttonAnimationDuration) {
            self.saveButton.alpha = enabled ? SettingsDisplayModel.buttonEnabledAlpha :
                SettingsDisplayModel.buttonDisabledAlpha
        }
    }

}
