protocol DateInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(dateCell: DateInputCellModelForViewModelType) -> Date
    func didChange(dateCell: DateInputCellModelForViewModelType, value: Date)

}

protocol DateInputCellModelForViewModelType: InputCellModelForViewModelType {

    var currentValue: Date { get }

}

class DateInputCellModel {

    enum Mode {
        case date, dateAndTime
    }

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: DateInputCellModelViewModelDelegate?

    lazy var toolbar = KeyboardToolbar(doneAction: { self.didEndEditing() })

    let label: String

    private let picker = UIDatePicker()
    private let formatter: DateFormatter
    private var cachedValue: Date?

    init(label: String, mode: Mode) {
        self.label = label

        switch mode {
        case .date:
            formatter = Formatters.date
            picker.datePickerMode = .date
        case .dateAndTime:
            formatter = Formatters.dateTime
            picker.datePickerMode = .dateAndTime
        }

        picker.addTarget(self,
                         action: #selector(pickerDidChange),
                         for: .valueChanged)
    }

    @objc func pickerDidChange() {
        cachedValue = picker.date
        viewDelegate?.update(value: formatter.string(from: picker.date))
        viewModelDelegate?.didChange(dateCell: self, value: picker.date)
    }

}

extension DateInputCellModel: InputCellModelForViewType {

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
            return formatter.string(from: cachedValue)
        }

        let value = viewModelDelegate?.defaultValue(dateCell: self) ?? Date()
        cachedValue = value
        let valueString = formatter.string(from: value)
        return valueString
    }

    func willBeginEditing() {
        picker.maximumDate = Date()
    }

    func didEndEditing() {
        viewDelegate?.resignFirstResponder()
    }

}

extension DateInputCellModel: DateInputCellModelForViewModelType {

    var currentValue: Date {
        return cachedValue ?? Date()
    }

    var isValid: Bool { return true }

    func becomeFirstResponder() {
        viewDelegate?.becomeFirstResponder()
    }

}
