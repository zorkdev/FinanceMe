// MARK: - View

struct InputCellDisplayModel {

    let placeholderAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.foregroundColor: ColorPalette.lightText.withAlphaComponent(0.5),
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)
    ]

    let selectionStyle = UITableViewCellSelectionStyle.none
    let enabledTextColor = ColorPalette.secondary
    let disabledTextColor = ColorPalette.lightText
    let labelColor = ColorPalette.lightText
    let tintColor = ColorPalette.secondary
    let font = UIFont.systemFont(ofSize: 18)

}

protocol InputCellModelViewDelegate: class {

    var currentValue: String { get }

    func update()
    func update(value: String)
    func becomeFirstResponder()
    func resignFirstResponder()

}

protocol InputCellModelForViewType: class {

    var viewDelegate: InputCellModelViewDelegate? { get set }

    var displayModel: InputCellDisplayModel { get }

    var keyboardType: UIKeyboardType { get }
    var textContentType: UITextContentType { get }
    var returnKeyType: UIReturnKeyType { get }
    var isSecureTextEntry: Bool { get }
    var autocapitalizationType: UITextAutocapitalizationType { get }
    var label: String { get }
    var placeholder: String { get }
    var defaultValue: String { get }
    var inputView: UIView? { get }
    var inputAccessoryView: UIView? { get }
    var textColor: Color { get }
    var tintColor: Color { get }
    var isEnabled: Bool { get }

    func willBeginEditing()
    func willChange(value: String, original: String) -> String
    func didChange(value: String)
    func didEndEditing()

}

extension InputCellModelForViewType {

    var displayModel: InputCellDisplayModel { return InputCellDisplayModel() }

    var keyboardType: UIKeyboardType { return .default }
    var textContentType: UITextContentType { return UITextContentType("") }
    var isSecureTextEntry: Bool { return false }
    var autocapitalizationType: UITextAutocapitalizationType { return .none }
    var inputView: UIView? { return nil }
    var inputAccessoryView: UIView? { return nil }
    var tintColor: Color { return displayModel.tintColor }

    var textColor: Color {
        return isEnabled ? displayModel.enabledTextColor : displayModel.disabledTextColor
    }

    func willBeginEditing() {}
    func willChange(value: String, original: String) -> String { return value }
    func didChange(value: String) {}

}

// MARK: - ViewModel

protocol InputCellModelViewModelDelegate: class {

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool
    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType

}

protocol InputCellModelForViewModelType: CellModelType {

    var isValid: Bool { get }

    func becomeFirstResponder()

}

extension InputCellModelForViewModelType {

    static var reuseIdentifier: String {
        return InputTableViewCell.reuseIdentifier
    }

}
