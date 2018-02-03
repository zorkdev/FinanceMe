import Foundation

public struct Formatters {

    public static let apiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Foundation.TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

    public static let apiDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Foundation.TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        return formatter
    }()

    public static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter
    }()

    public static let dateWithoutYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"

        return formatter
    }()

    public static let dateWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"

        return formatter
    }()

    public static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        return formatter
    }()

    public static let currencyPlusSign: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.positivePrefix = formatter.plusSign + formatter.currencySymbol
        formatter.negativePrefix = formatter.currencySymbol

        return formatter
    }()

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
