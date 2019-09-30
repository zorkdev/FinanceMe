public enum TransactionDirection: String, Codable {
    case outbound = "OUTBOUND"
    case inbound = "INBOUND"
}

public enum TransactionSource: String, Codable {
    case externalRegularInbound = "EXTERNAL_REGULAR_INBOUND"
    case externalRegularOutbound = "EXTERNAL_REGULAR_OUTBOUND"
    case externalInbound = "EXTERNAL_INBOUND"
    case externalOutbound = "EXTERNAL_OUTBOUND"
}

public struct Transaction: Storeable, Identifiable, Equatable {
    public let id: UUID
    public let amount: Decimal
    public let direction: TransactionDirection
    public let created: Date
    public let narrative: String
    public let source: TransactionSource
}
