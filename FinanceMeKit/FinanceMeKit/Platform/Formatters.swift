enum Formatters {
    static let locale = Locale(identifier: "en_GB")

    #if os(iOS) || os(macOS)
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.isLenient = true
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        return formatter
    }()

    static let relativeDateFormatter: DateFormatter = {
        let formatter = createDateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .full
        return formatter
    }()

    static let year: DateFormatter = {
        let formatter = createDateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    static let month: DateFormatter = {
        let formatter = createDateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    #endif
}

#if os(iOS) || os(macOS)
private extension Formatters {
    static func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = locale.calendar
        formatter.timeZone = locale.calendar.timeZone
        return formatter
    }
}
#endif
