extension NumberFormatter {
    func string(from decimal: Decimal) -> String {
        string(from: decimal as NSDecimalNumber)!
    }

    func decimal(from string: String) -> Decimal? {
        number(from: string)?.decimalValue
    }
}
