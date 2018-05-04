protocol AmountInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(amountCell: AmountInputCellModelForViewModelType) -> Double?

}

protocol AmountInputCellModelForViewModelType: InputCellModelForViewModelType {

    var viewModelDelegate: AmountInputCellModelViewModelDelegate? { get set }
    var currentValue: Double? { get }

    func update(value: Double?)

}

class AmountInputCellModel {

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: AmountInputCellModelViewModelDelegate?

    lazy var toolbar = KeyboardToolbar(doneAction: { self.didEndEditing() })

    let label: String

    private let formatter = Formatters.currencyNoSign
    private var cachedValue: String?

    init(label: String) {
        self.label = label
    }

    private func validate(value: String) -> Bool {
        return Validators.validate(amount: value)
    }

}

extension AmountInputCellModel: InputCellModelForViewType {

    var keyboardType: UIKeyboardType { return .decimalPad }
    var returnKeyType: UIReturnKeyType { return viewModelDelegate?.returnKeyType(inputCell: self) ?? .done }

    var inputAccessoryView: UIView? {
        return UIDevice.current.userInterfaceIdiom == .phone ? toolbar.toolbar : nil
    }

    var placeholder: String {
        return formatter.string(from: 0)
    }

    var isEnabled: Bool {
        return viewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    var defaultValue: String {
        if let cachedValue = cachedValue {
            return cachedValue
        }

        guard let value = viewModelDelegate?.defaultValue(amountCell: self) else { return "" }
        let valueString = formatter.string(from: value)
        cachedValue = valueString
        return valueString
    }

    func willChange(value: String, original: String) -> String {
        let sanitisedValue = Formatters.sanitise(amount: value)
        return validate(value: sanitisedValue) ? sanitisedValue : original
    }

    func didChange(value: String) {
        cachedValue = value
        viewModelDelegate?.didChangeValue()
    }

    func didEndEditing() {
        viewDelegate?.resignFirstResponder()
    }

}

extension AmountInputCellModel: AmountInputCellModelForViewModelType {

    var currentValue: Double? {
        let valueString = viewDelegate?.currentValue ?? ""
        return Formatters.createAmount(from: valueString)
    }

    var isValid: Bool {
        guard let value = viewDelegate?.currentValue,
            Validators.validate(fullAmount: value) else { return false }
        return true
    }

    func becomeFirstResponder() {
        viewDelegate?.becomeFirstResponder()
    }

    func update(value: Double?) {
        var valueString = ""
        if let value = value {
            valueString = formatter.string(from: value)
        }
        cachedValue = valueString
        viewDelegate?.update(value: valueString)
    }

}
