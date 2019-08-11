public struct AmountViewModel {
    public enum Sign {
        case plus
        case minus
    }

    private static let integerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Formatters.locale
        formatter.numberStyle = .decimal
        formatter.negativePrefix = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    private static let fractionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Formatters.locale
        formatter.numberStyle = .decimal
        formatter.negativePrefix = ""
        formatter.decimalSeparator = ""
        formatter.maximumIntegerDigits = 0
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    public let value: Decimal

    public let sign: String
    public let currencySymbol: String
    public let integer: String
    public let decimalSeparator: String
    public let fraction: String
    public let string: String

    public init(value: Decimal, signs: [Sign] = [.minus]) {
        self.value = value

        if value.isSignMinus, signs.contains(.minus) {
            sign = Self.integerFormatter.minusSign
        } else if value.isSignMinus == false, signs.contains(.plus) {
            sign = Self.integerFormatter.plusSign
        } else {
            sign = ""
        }

        currencySymbol = Formatters.locale.currencySymbol!
        integer = Self.integerFormatter.string(for: value)!
        decimalSeparator = Formatters.locale.decimalSeparator!
        fraction = Self.fractionFormatter.string(for: value)!
        string = sign + currencySymbol + integer + decimalSeparator + fraction
    }
}
