public struct Balance: Storeable, Equatable {

    public let clearedBalance: Double
    public let effectiveBalance: Double
    public let pendingTransactions: Double
    public let availableToSpend: Double
    public let acceptedOverdraft: Double
    public let currency: String
    public let amount: Double

}
