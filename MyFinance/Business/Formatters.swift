import Foundation

struct AmountFormatter {

    static func format(amount: Double) -> String {
        return String(format: "£%.2f", amount)
    }

}
