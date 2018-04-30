protocol TextInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(textCell: TextInputCellModelForViewModelType) -> String?
    func didChange(textCell: TextInputCellModelForViewModelType, value: String)

}

protocol TextInputCellModelForViewModelType: InputCellModelForViewModelType {

    var currentValue: String? { get }

}

class TextInputCellModel {

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: TextInputCellModelViewModelDelegate?

    private var cachedValue: String?

    let label: String
    let placeholder: String

    init(label: String, placeholder: String) {
        self.label = label
        self.placeholder = placeholder
    }

    private func validate(value: String) -> Bool {
        return value.components(separatedBy: .whitespaces).joined().isEmpty == false
    }

}

extension TextInputCellModel: InputCellModelForViewType {

    var returnKeyType: UIReturnKeyType { return viewModelDelegate?.returnKeyType(inputCell: self) ?? .done }
    var autocapitalizationType: UITextAutocapitalizationType { return .words }

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

    func willChange(value: String, original: String) -> String {
        return value
    }

    func didChange(value: String) {
        cachedValue = value
        viewModelDelegate?.didChange(textCell: self, value: currentValue ?? "")
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

}
