class SecureTextInputCellModel: TextInputCellModel {

    override var textContentType: UITextContentType { return .password }
    override var isSecureTextEntry: Bool { return true }

}
