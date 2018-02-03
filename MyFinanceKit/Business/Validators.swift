import Foundation

public struct Validators {

    private static let amountCharacterSet: CharacterSet = {
        var decimalDigits = CharacterSet.decimalDigits
        decimalDigits.insert(".")
        return decimalDigits
    }()

    public static func validate(amount: String) -> Bool {
        return amount.range(of: "^(0\\.?|0\\.\\d{0,2}|[1-9]\\d{0,6}|[1-9]\\d{0,6}\\.\\d{0,2})$",
                            options: .regularExpression) != nil
    }

}
