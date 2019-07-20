enum AmountDisplayModelType {
    case plus
    case minus
    case plusMinus
}

extension AmountDisplayModelType {
    var formatter: NumberFormatter {
        switch self {
        case .plus: return Formatters.currencyPlusSign
        case .minus: return Formatters.currency
        case .plusMinus: return Formatters.currencyPlusMinusSign
        }
    }

    func color(forAmount: Double) -> Color {
        let isPositive = forAmount >= 0

        switch self {
        case .plus: return isPositive ? ColorPalette.green : ColorPalette.darkText
        case .minus: return isPositive ? ColorPalette.darkText : ColorPalette.red
        case .plusMinus: return isPositive ? ColorPalette.green : ColorPalette.red
        }
    }
}
