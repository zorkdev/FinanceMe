public struct Validators {

    public static func validate(amount: String) -> Bool {
        let cs = Formatters.currencySymbol
        let regex = "^(\(cs)?0\\.?|\(cs)?0\\.\\d{0,2}|\(cs)?[1-9]\\d{0,6}|\(cs)?[1-9]\\d{0,6}\\.\\d{0,2})$"

        return amount.range(of: regex, options: .regularExpression) != nil
    }

}
