import SwiftUI

struct AmountViewModel {
    enum Sign {
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

    let value: Decimal

    let sign: String
    let currencySymbol: String
    let integer: String
    let decimalSeparator: String
    let fraction: String
    let string: String
    let integerString: String
    let isNegative: Bool
    let color: Color?

    init(value: Decimal, signs: [Sign] = [.minus]) {
        self.value = value

        if value.isSignMinus, signs.contains(.minus) {
            sign = Self.integerFormatter.minusSign
            color = .red
        } else if value.isSignMinus == false, signs.contains(.plus) {
            sign = Self.integerFormatter.plusSign
            color = .green
        } else {
            sign = ""
            color = nil
        }

        currencySymbol = Formatters.locale.currencySymbol!
        integer = Self.integerFormatter.string(for: value.integer)!
        decimalSeparator = Formatters.locale.decimalSeparator!
        fraction = Self.fractionFormatter.string(for: value.fraction)!
        string = sign + currencySymbol + integer + decimalSeparator + fraction
        integerString = sign + integer
        isNegative = value < 0
    }
}
