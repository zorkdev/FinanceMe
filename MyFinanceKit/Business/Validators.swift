public enum Validators {
    public static func validate(string: String) -> Bool {
        return string.components(separatedBy: .whitespaces).joined().isEmpty == false
    }

    public static func validate(amount: String) -> Bool {
        let cs = Formatters.currencySymbol
        let ds = Formatters.decimalSeparator
        let regex = "^(|\(cs)?0\\\(ds)?|\(cs)?0\\\(ds)\\d{0,2}|\(cs)?[1-9]\\d{0,6}|\(cs)?[1-9]\\d{0,6}\\\(ds)\\d{0,2})$"

        return amount.range(of: regex, options: .regularExpression) != nil
    }

    public static func validate(fullAmount: String) -> Bool {
        guard validate(amount: fullAmount),
            let amount = Formatters.createAmount(from: fullAmount),
            amount != 0 else { return false }

        return true
    }

    public static func validate(email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-@]*$"

        return email.range(of: regex, options: .regularExpression) != nil
    }

    public static func validate(fullEmail: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        return fullEmail.range(of: regex, options: .regularExpression) != nil
    }
}
