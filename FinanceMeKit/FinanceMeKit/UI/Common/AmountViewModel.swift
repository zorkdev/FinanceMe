import SwiftUI

struct AmountViewModel {
    enum Sign {
        case plus
        case minus

        static func ~= (pattern: Self, value: [Self]) -> Bool { value.contains(pattern) }
    }

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Formatters.locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    let value: Double

    let sign: String
    let currencySymbol: String
    let integer: String
    let decimalSeparator: String
    let fraction: String
    let string: String
    let integerString: String
    let color: Color?

    init(value: Double, signs: [Sign] = [.minus]) {
        self.value = value

        switch (value.sign, signs) {
        case _ where value == .zero:
            sign = ""
            color = nil
        case (.minus, .minus):
            sign = Self.formatter.minusSign
            color = .red
        case (.plus, .plus):
            sign = Self.formatter.plusSign
            color = .green
        default:
            sign = ""
            color = nil
        }

        let components = Self.components(value: value)

        currencySymbol = Self.formatter.currencySymbol
        integer = components.integer
        decimalSeparator = Self.formatter.decimalSeparator
        fraction = components.fraction
        string = sign + currencySymbol + integer + decimalSeparator + fraction
        integerString = sign + integer
    }

    private static func components(value: Double) -> (integer: String, fraction: String) {
        let components = formatter
            .string(from: abs(value))
            .components(separatedBy: formatter.decimalSeparator)
        return (components[0], components[1])
    }
}
