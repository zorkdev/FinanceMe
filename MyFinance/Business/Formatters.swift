struct Formatters {

    static let apiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Foundation.TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

    static let apiDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Foundation.TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return formatter
    }()

    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        return formatter
    }()

    static let currencyPlusSign: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.positivePrefix = formatter.plusSign + formatter.currencySymbol
        formatter.negativePrefix = formatter.currencySymbol

        return formatter
    }()

}
