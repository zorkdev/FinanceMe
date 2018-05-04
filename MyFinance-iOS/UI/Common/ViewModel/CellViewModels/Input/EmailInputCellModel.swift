class EmailInputCellModel: TextInputCellModel {

    override var keyboardType: UIKeyboardType { return .emailAddress }
    override var textContentType: UITextContentType { return .emailAddress }
    override var autocapitalizationType: UITextAutocapitalizationType { return .none }

    init() {
        super.init(label: "Email", placeholder: "")
    }

    override func validate(value: String) -> Bool {
        return Validators.validate(fullEmail: value)
    }

    override func willChange(value: String, original: String) -> String {
        let sanitisedValue = Formatters.sanitise(email: value)
        return Validators.validate(email: sanitisedValue) ? sanitisedValue : original
    }

}
