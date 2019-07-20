protocol DateInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {
    func defaultValue(dateCell: DateInputCellModelForViewModelType) -> Date
}

protocol DateInputCellModelForViewModelType: InputCellModelForViewModelType {
    var viewModelDelegate: DateInputCellModelViewModelDelegate? { get set }
    var currentValue: Date { get }

    func update(value: Date)
}

class DateInputCellModel {
    enum Mode {
        case date, dateAndTime
    }

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: DateInputCellModelViewModelDelegate?

    lazy var toolbar = KeyboardToolbar { self.didEndEditing() }

    let label: String

    private let picker = UIDatePicker()
    private let formatter: DateFormatter

    private var cachedValue: Date? {
        didSet {
            picker.setDate(cachedValue ?? Date(), animated: false)
        }
    }

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

    @objc
    func pickerDidChange() {
        cachedValue = picker.date
        viewDelegate?.update(value: formatter.string(from: picker.date))
        viewModelDelegate?.didChangeValue()
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

    func update(value: Date) {
        cachedValue = value
        viewDelegate?.update(value: formatter.string(from: value))
    }
}
