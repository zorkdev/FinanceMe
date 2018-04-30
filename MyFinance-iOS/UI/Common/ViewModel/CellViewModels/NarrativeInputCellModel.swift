protocol NarrativeInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(narrativeCell: NarrativeInputCellModelForViewModelType) -> String?
    func didChange(narrativeCell: NarrativeInputCellModelForViewModelType, value: String)

}

protocol NarrativeInputCellModelForViewModelType: InputCellModelForViewModelType {

    var currentValue: String? { get }

}

class NarrativeInputCellModel {

    weak var viewDelegate: InputCellModelViewDelegate?
    weak var viewModelDelegate: NarrativeInputCellModelViewModelDelegate?

    private var cachedValue: String?

    private func validate(value: String) -> Bool {
        return value.components(separatedBy: .whitespaces).joined().isEmpty == false
    }

}

extension NarrativeInputCellModel: InputCellModelForViewType {

    var returnKeyType: UIReturnKeyType { return viewModelDelegate?.returnKeyType(inputCell: self) ?? .done }
    var autocapitalizationType: UITextAutocapitalizationType { return .words }
    var label: String { return "Narrative" }
    var placeholder: String { return "Groceries" }

    var isEnabled: Bool {
        return viewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    var defaultValue: String {
        if let cachedValue = cachedValue {
            return cachedValue
        }

        let value = viewModelDelegate?.defaultValue(narrativeCell: self) ?? ""
        cachedValue = value
        return value
    }

    func willChange(value: String, original: String) -> String {
        return value
    }

    func didChange(value: String) {
        cachedValue = value
        viewModelDelegate?.didChange(narrativeCell: self, value: currentValue ?? "")
    }

    func didEndEditing() {
        viewDelegate?.resignFirstResponder()
    }

}

extension NarrativeInputCellModel: NarrativeInputCellModelForViewModelType {

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
