protocol PickerInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(pickerCell: PickerInputCellModelForViewModelType) -> Describable

}

protocol PickerInputCellModelForViewModelType: InputCellModelForViewModelType {

    var viewModelDelegate: PickerInputCellModelViewModelDelegate? { get set }
    var currentValue: Describable { get }

    func update(value: Describable)

}

class PickerInputCellModel: NSObject {

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: PickerInputCellModelViewModelDelegate?

    lazy var toolbar = KeyboardToolbar(doneAction: { self.didEndEditing() })

    let label: String

    private let picker = UIPickerView()

    private var cachedValue: Describable? {
        didSet {
            var row = 0
            if let value = cachedValue,
                let index = rows.firstIndex(where: { $0.description == value.description }) {
                row = index
            }
            picker.selectRow(row, inComponent: 0, animated: false)
        }
    }

    private let rows: [Describable]

    init(label: String, rows: [Describable]) {
        self.label = label
        self.rows = rows

        super.init()

        picker.delegate = self
        picker.dataSource = self
    }

}

extension PickerInputCellModel: InputCellModelForViewType {

    var returnKeyType: UIReturnKeyType { return viewModelDelegate?.returnKeyType(inputCell: self) ?? .done }
    var inputAccessoryView: UIView? { return toolbar.toolbar }
    var inputView: UIView? { return picker }
    var placeholder: String { return "" }
    var tintColor: Color { return .clear }

    var isEnabled: Bool {
        return viewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    var defaultValue: String {
        if let cachedValue = cachedValue {
            return cachedValue.description
        }

        guard let value = viewModelDelegate?.defaultValue(pickerCell: self) else { return "" }
        cachedValue = value
        return value.description
    }

    func didEndEditing() {
        viewDelegate?.resignFirstResponder()
    }

}

extension PickerInputCellModel: PickerInputCellModelForViewModelType {

    var currentValue: Describable {
        return cachedValue ?? rows.first!
    }

    var isValid: Bool { return true }

    func becomeFirstResponder() {
        viewDelegate?.becomeFirstResponder()
    }

    func update(value: Describable) {
        cachedValue = value
        viewDelegate?.update(value: value.description)
    }

}

extension PickerInputCellModel: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows.count
    }

}

extension PickerInputCellModel: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rows[row].description
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = rows[row]
        cachedValue = item
        viewDelegate?.update(value: item.description)
        viewModelDelegate?.didChangeValue()
    }

}
