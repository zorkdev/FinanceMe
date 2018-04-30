class InputTableViewCell: UITableViewCell {

    @IBOutlet private weak var textField: UITextField!

    private weak var viewModel: InputCellModelForViewType!

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel.viewDelegate = nil
        viewModel = nil
    }

}

extension InputTableViewCell: TableViewCellForViewModelType {

    func update(viewModel: CellModelType) {
        guard let viewModel = viewModel as? InputCellModelForViewType else { return }

        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
        textField.delegate = self

        selectionStyle = viewModel.displayModel.selectionStyle
        textField.tintColor = viewModel.displayModel.tintColor
        textField.font = viewModel.displayModel.font

        update()
    }

}

extension InputTableViewCell: InputCellModelViewDelegate {

    var currentValue: String {
        return textField.text ?? ""
    }

    func update() {
        textField.keyboardType = viewModel.keyboardType
        textField.autocapitalizationType = viewModel.autocapitalizationType
        textField.inputView = viewModel.inputView
        textField.inputAccessoryView = viewModel.inputAccessoryView
        textField.setLeftLabel(text: viewModel.label, color: viewModel.displayModel.labelColor)
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder,
                                                             attributes: viewModel.displayModel.placeholderAttributes)
        textField.text = viewModel.defaultValue
        textField.textColor = viewModel.textColor
        textField.isUserInteractionEnabled = viewModel.isEnabled
        textField.isSecureTextEntry = viewModel.isSecureTextEntry
    }

    func becomeFirstResponder() {
        textField.becomeFirstResponder()
    }

    func resignFirstResponder() {
        textField.resignFirstResponder()
    }

}

extension InputTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let originalText = textField.text,
            let range = Range(range, in: originalText)  else { return false }

        let newText = originalText.replacingCharacters(in: range, with: string)
        textField.text = viewModel.willChange(value: newText, original: originalText)
        viewModel.didChange(value: textField.text ?? "")

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.didEndEditing()
        return true
    }

}
