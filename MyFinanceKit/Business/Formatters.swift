public struct Formatters {

    public static let locale = Locale(identifier: "en_GB")
    public static let apiLocale = Locale(identifier: "en_US_POSIX")
    public static let apiTimeZone = Foundation.TimeZone(abbreviation: "UTC")

    public static let currencySymbol = {
        return locale.currencySymbol ?? "£"
    }()

    public static let decimalSeparator = {
        return locale.decimalSeparator ?? "."
    }()

    public static let apiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = apiTimeZone
        formatter.locale = apiLocale
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

    public static let apiDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = apiTimeZone
        formatter.locale = apiLocale
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"

        return formatter
    }()

    public static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "d MMM yyyy"

        return formatter
    }()

    public static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "d MMM yyyy' at 'H:mm"

        return formatter
    }()

    public static let dateWithoutYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE, d MMMM"

        return formatter
    }()

    public static let dateWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE, d MMMM yyyy"

        return formatter
    }()

    public static let month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "MMMM"

        return formatter
    }()

    public static let monthShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "MMM"

        return formatter
    }()

    public static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "yyyy"

        return formatter
    }()

    public static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency

        return formatter
    }()

    public static let currencyNoSign: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.positivePrefix = formatter.currencySymbol
        formatter.negativePrefix = formatter.currencySymbol
        formatter.groupingSeparator = ""

        return formatter
    }()

    public static let currencyPlusSign: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.positivePrefix = formatter.plusSign + formatter.currencySymbol
        formatter.negativePrefix = formatter.currencySymbol

        return formatter
    }()

    public static let currencyPlusMinusSign: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.positivePrefix = formatter.plusSign + formatter.currencySymbol
        formatter.negativePrefix = formatter.minusSign + formatter.currencySymbol

        return formatter
    }()

    public static let currencyNoFractions: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0

        return formatter
    }()

    public static func createAmount(from: String) -> Double? {
        let amountString = from
            .components(separatedBy: .whitespaces)
            .joined()
            .replacingOccurrences(of: currencySymbol, with: "")

        return Double(amountString)
    }

    public static func sanitise(amount: String) -> String {
        var amountTemp = amount
        amountTemp = amountTemp.replacingOccurrences(of: ",", with: decimalSeparator)

        if amountTemp.contains(currencySymbol) == false {
            amountTemp.insert(Character(currencySymbol), at: amountTemp.startIndex)
        } else if amountTemp == currencySymbol {
            return ""
        }

        return amountTemp
    }

    public static func sanitise(email: String) -> String {
        return email.components(separatedBy: .whitespaces).joined()
    }

    public static func formatRelative(date: Date) -> String {
        switch date {
        case _ where date.isToday:
            return "Today"
        case _ where date.isYesterday:
            return "Yesterday"
        case _ where date.isThisYear:
            return dateWithoutYear.string(from: date)
        default:
            return dateWithYear.string(from: date)
        }
    }

}
