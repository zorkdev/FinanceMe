public extension NumberFormatter {
    func string(from decimal: Decimal) -> String {
        return string(from: decimal as NSDecimalNumber)!
    }

    func decimal(from string: String) -> Decimal? {
        return number(from: string)?.decimalValue
    }
}
