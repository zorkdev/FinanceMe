public struct AmountViewModel {
    public enum Sign {
        case plus
        case minus
    }

    private static let integerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Formatters.locale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .floor
        return formatter
    }()

    private static let fractionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Formatters.locale
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    public let value: Decimal

    public let sign: String
    public let currencySymbol: String
    public let integer: String
    public let decimalSeparator: String
    public let fraction: String
    public let string: String
    public let integerString: String

    public var isNegative: Bool { value < 0 }

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
        integer = Self.integerFormatter.string(for: value.integer)!
        decimalSeparator = Formatters.locale.decimalSeparator!
        fraction = Self.fractionFormatter.string(for: value.fraction)!
        string = sign + currencySymbol + integer + decimalSeparator + fraction
        integerString = sign + integer
    }
}
