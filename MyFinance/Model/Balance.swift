import Foundation

struct Balance: Codable {

    let clearedBalance: Double
    let effectiveBalance: Double
    let pendingTransactions: Double
    let availableToSpend: Double
    let acceptedOverdraft: Double
    let currency: String
    let amount: Double

}
