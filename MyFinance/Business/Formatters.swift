import Foundation

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

    static func format(amount: Double) -> String {
        return String(format: "£%.2f", amount)
    }

}
