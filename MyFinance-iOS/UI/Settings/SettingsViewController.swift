class SettingsViewController: BaseViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var largeTransactionField: UITextField!
    @IBOutlet private weak var paydayField: UITextField!
    @IBOutlet private weak var startDateField: UITextField!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    private var viewModel: SettingsViewModelType!

    private let startDatePicker = UIDatePicker()
    private var selectedDate = Date()

    private let paydayPicker = UIPickerView()

    weak var dataDelegate: SettingsViewModelDataDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SettingsViewModel(serviceProvider: appState,
                                      delegate: self,
                                      dataDelegate: dataDelegate)
        setupTextFields()
        viewModel.viewDidLoad()
    }

    private func setupTextFields() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            largeTransactionField.inputAccessoryView = keyBoardToolbar
        }

        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self,
                                  action: #selector(startDatePickerValueChanged(_:)),
                                  for: .valueChanged)
        startDateField.inputView = startDatePicker
        startDateField.inputAccessoryView = keyBoardToolbar
        startDateField.tintColor = .clear

        paydayPicker.delegate = self
        paydayPicker.dataSource = self
        paydayField.inputView = paydayPicker
        paydayField.inputAccessoryView = keyBoardToolbar
        paydayField.tintColor = .clear

        updateSaveButton()
    }

    private func updateSaveButton() {
        let settingsDisplayModel = SettingsDisplayModel(name: nameField.text ?? "",
                                                        largeTransaction: largeTransactionField.text ?? "",
                                                        payday: paydayField.text ?? "",
                                                        startDate: selectedDate)

        let shouldEnable = viewModel.shouldEnableSaveButton(displayModel: settingsDisplayModel)

        saveButton.isEnabled = shouldEnable

        UIView.animate(withDuration: SettingsDisplayModel.buttonAnimationDuration) {
            self.saveButton.alpha = shouldEnable ? SettingsDisplayModel.buttonEnabledAlpha :
                SettingsDisplayModel.buttonDisabledAlpha
        }
    }

    @objc private func startDatePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        startDateField.text = SettingsDisplayModel.dateString(from: selectedDate)
    }

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameField.text,
            name.components(separatedBy: .whitespaces)
                .joined() != "",
            let largeTransaction = largeTransactionField.text,
            largeTransaction.components(separatedBy: .whitespaces)
                .joined() != "" else { return }

        let settingsDisplayModel = SettingsDisplayModel(name: name,
                                                        largeTransaction: largeTransaction,
                                                        payday: paydayField.text ?? "",
                                                        startDate: selectedDate)

        viewModel.saveButtonTapped(with: settingsDisplayModel)
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        viewModel.editButtonTapped()
    }

}

extension SettingsViewController: SettingsViewModelDelegate {

    func setupDefault(displayModel: SettingsDisplayModel) {
        nameField.text = displayModel.name
        largeTransactionField.text = displayModel.largeTransaction
        paydayField.text = displayModel.payday
        let selection = viewModel.pickerViewRowInComponent(for: displayModel.payday)
        paydayPicker.selectRow(selection.row, inComponent: selection.component, animated: false)
        startDateField.text = SettingsDisplayModel.dateString(from: displayModel.startDate)
        selectedDate = displayModel.startDate
        startDatePicker.setDate(selectedDate, animated: false)
        updateSaveButton()
    }

    func update(editing: Bool) {
        nameField.textColor = editing ? ColorPalette.secondary : ColorPalette.lightText
        largeTransactionField.textColor = editing ? ColorPalette.secondary : ColorPalette.lightText
        paydayField.textColor = editing ? ColorPalette.secondary : ColorPalette.lightText
        startDateField.textColor = editing ? ColorPalette.secondary : ColorPalette.lightText

        nameField.isEnabled = editing
        largeTransactionField.isEnabled = editing
        paydayField.isEnabled = editing
        startDateField.isEnabled = editing
        saveButton.isHidden = !editing
        let editButtonTitle = editing ? SettingsDisplayModel.cancelButtonTitle :
                                        SettingsDisplayModel.editButtonTitle
        editButton.setTitle(editButtonTitle, for: .normal)

        if editing {
            nameField.becomeFirstResponder()
        }
    }

}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponentsInPickerView()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerViewNumberOfRowsIn(component: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerViewTitle(for: row, for: component)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paydayField.text = viewModel.pickerViewTitle(for: row, for: component)
    }

}

extension SettingsViewController {

    @IBAction private func textFieldValueChanged(_ sender: UITextField) {
        updateSaveButton()
    }

    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        startDatePicker.maximumDate = Date()
        return true
    }

    private func textField(_ textField: UITextField,
                           shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool {
        guard textField == largeTransactionField,
            let originalText = textField.text,
            let range = Range(range, in: originalText)  else { return true }

        let text = originalText.replacingCharacters(in: range, with: string)
        textField.text = viewModel.formatted(amount: text, original: originalText)
        updateSaveButton()

        return false
    }

}
