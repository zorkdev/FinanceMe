class AddTransactionViewController: BaseViewController {

    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var narrativeField: UITextField!
    @IBOutlet private weak var sourcePicker: UIPickerView!
    @IBOutlet private weak var datePicker: UIDatePicker!

    private var viewModel: AddTransactionViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddTransactionViewModel(delegate: self)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let amount = amountField.text,
            amount.components(separatedBy: .whitespaces)
                .joined() != "",
            let narrative = narrativeField.text,
            narrative.components(separatedBy: .whitespaces)
                .joined() != "" else { return }

        let source = sourcePicker.selectedRow(inComponent: 0)
        let addTransactionDisplayModel = AddTransactionDisplayModel(amount: amount,
                                                                    narrative: narrative,
                                                                    source: source,
                                                                    created: datePicker.date)
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

}

extension AddTransactionViewController: AddTransactionViewModelDelegate {}
