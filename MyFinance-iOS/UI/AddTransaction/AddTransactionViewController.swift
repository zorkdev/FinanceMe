class AddTransactionViewController: BaseViewController {

    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var narrativeField: UITextField!
    @IBOutlet private weak var sourceField: UITextField!
    @IBOutlet private weak var createdField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!

    private var viewModel: AddTransactionViewModelType!

    private let createdPicker = UIDatePicker()
    private var selectedSource = 0
    private var selectedDate = Date()

    weak var dataDelegate: AddTransactionViewModelDataDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appState = appState else { return }
        viewModel = AddTransactionViewModel(networkServiceProvider: appState,
                                            delegate: self,
                                            dataDelegate: dataDelegate)
        setupTextFields()
    }

    private func setupTextFields() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            amountField.inputAccessoryView = keyBoardToolbar
        }

        createdPicker.addTarget(self,
                                action: #selector(createdPickerValueChanged(_:)),
                                for: .valueChanged)
        createdField.inputView = createdPicker
        createdField.inputAccessoryView = keyBoardToolbar
        createdField.tintColor = .clear
        createdField.text = AddTransactionDisplayModel.dateString(from: selectedDate)

        let sourcePicker = UIPickerView()
        sourcePicker.delegate = self
        sourcePicker.dataSource = self
        sourceField.inputView = sourcePicker
        sourceField.inputAccessoryView = keyBoardToolbar
        sourceField.tintColor = .clear
        sourceField.text = viewModel.pickerViewTitle(for: selectedSource, for: 0)

        updateSaveButton()

        amountField.becomeFirstResponder()
    }

    private func updateSaveButton() {
        let addTransactionDisplayModel = AddTransactionDisplayModel(amount: amountField.text ?? "",
                                                                    narrative: narrativeField.text ?? "",
                                                                    source: selectedSource,
                                                                    created: selectedDate)
        let shouldEnable = viewModel.shouldEnableSaveButton(displayModel: addTransactionDisplayModel)

        saveButton.isEnabled = shouldEnable

        UIView.animate(withDuration: AddTransactionDisplayModel.buttonAnimationDuration) {
            self.saveButton.alpha = shouldEnable ? AddTransactionDisplayModel.buttonEnabledAlpha :
                                                   AddTransactionDisplayModel.buttonDisabledAlpha
        }
    }

    @objc private func createdPickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        createdField.text = AddTransactionDisplayModel.dateString(from: selectedDate)
    }

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        guard let amount = amountField.text,
            amount.components(separatedBy: .whitespaces)
                .joined() != "",
            let narrative = narrativeField.text,
            narrative.components(separatedBy: .whitespaces)
                .joined() != "" else { return }

        let addTransactionDisplayModel = AddTransactionDisplayModel(amount: amount,
                                                                    narrative: narrative,
                                                                    source: selectedSource,
                                                                    created: selectedDate)
        viewModel.saveButtonTapped(with: addTransactionDisplayModel)
    }

}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
        selectedSource = row
        sourceField.text = viewModel.pickerViewTitle(for: row, for: component)
    }

}

extension AddTransactionViewController {

    @IBAction private func textFieldValueChanged(_ sender: UITextField) {
        updateSaveButton()
    }

    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        createdPicker.maximumDate = Date()
        return true
    }

    private func textField(_ textField: UITextField,
                           shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool {
        guard textField == amountField,
            let originalText = textField.text,
            let range = Range(range, in: originalText)  else { return true }

        let text = originalText.replacingCharacters(in: range, with: string)
        textField.text = viewModel.formatted(amount: text, original: originalText)
        updateSaveButton()

        return false
    }

}

extension AddTransactionViewController: AddTransactionViewModelDelegate {}
