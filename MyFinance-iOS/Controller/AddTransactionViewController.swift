class AddTransactionViewController: BaseViewController {

    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var narrativeField: UITextField!
    @IBOutlet private weak var sourceField: UITextField!
    @IBOutlet private weak var createdField: UITextField!

    private var viewModel: AddTransactionViewModel!

    private var selectedSource = 0
    private var selectedDate = Date()

    weak var dataDelegate: AddTransactionViewModelDataDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddTransactionViewModel(delegate: self, dataDelegate: dataDelegate)
        setupTextFields()
    }

    private func setupTextFields() {
        amountField.inputAccessoryView = keyBoardToolbar

        let createdPicker = UIDatePicker()
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
    }

    @objc func createdPickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        createdField.text = AddTransactionDisplayModel.dateString(from: selectedDate)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
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
