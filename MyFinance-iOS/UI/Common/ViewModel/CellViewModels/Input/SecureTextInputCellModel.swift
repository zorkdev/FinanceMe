class SecureTextInputCellModel: TextInputCellModel {

    override var textContentType: UITextContentType { return .password }
    override var isSecureTextEntry: Bool { return true }

    init(label: String) {
        super.init(label: label, placeholder: "")
    }

}
