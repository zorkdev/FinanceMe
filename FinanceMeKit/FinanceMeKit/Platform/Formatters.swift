enum Formatters {
    static let locale = Locale(identifier: "en_GB")

    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        return formatter
    }()
}
