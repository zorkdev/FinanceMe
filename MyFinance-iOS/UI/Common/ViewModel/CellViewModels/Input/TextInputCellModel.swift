protocol TextInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(textCell: TextInputCellModelForViewModelType) -> String?

}

protocol TextInputCellModelForViewModelType: InputCellModelForViewModelType {

    var viewModelDelegate: TextInputCellModelViewModelDelegate? { get set }
    var currentValue: String? { get }

    func update(value: String)

}

class TextInputCellModel {

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: TextInputCellModelViewModelDelegate?

    private var cachedValue: String?

    let label: String
    let placeholder: String

    var keyboardType: UIKeyboardType { return .default }
    var textContentType: UITextContentType { return UITextContentType(rawValue: "") }
    var autocapitalizationType: UITextAutocapitalizationType { return .words }
    var isSecureTextEntry: Bool { return false }

    init(label: String, placeholder: String) {
        self.label = label
        self.placeholder = placeholder
    }

    func validate(value: String) -> Bool {
        return Validators.validate(string: value)
    }

    func willChange(value: String, original: String) -> String {
        return value
    }

}

extension TextInputCellModel: InputCellModelForViewType {

    var returnKeyType: UIReturnKeyType { return viewModelDelegate?.returnKeyType(inputCell: self) ?? .done }

    var isEnabled: Bool {
        return viewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    var defaultValue: String {
        if let cachedValue = cachedValue {
            return cachedValue
        }

        let value = viewModelDelegate?.defaultValue(textCell: self) ?? ""
        cachedValue = value
        return value
    }

    func didChange(value: String) {
        cachedValue = value
        viewModelDelegate?.didChangeValue()
    }

    func didEndEditing() {
        viewDelegate?.resignFirstResponder()
    }

}

extension TextInputCellModel: TextInputCellModelForViewModelType {

    var currentValue: String? {
        return viewDelegate?.currentValue
    }

    var isValid: Bool {
        guard let value = viewDelegate?.currentValue,
            validate(value: value) else { return false }
        return true
    }

    func becomeFirstResponder() {
        viewDelegate?.becomeFirstResponder()
    }

    func update(value: String) {
        cachedValue = value
        viewDelegate?.update(value: value)
    }

}
