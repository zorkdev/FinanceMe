public struct Transaction: Storeable, Identifiable, Equatable {
    public enum Direction: String, Codable {
        case outbound = "OUTBOUND"
        case inbound = "INBOUND"
    }

    public enum Source: String, Codable {
        case externalRegularInbound = "EXTERNAL_REGULAR_INBOUND"
        case externalRegularOutbound = "EXTERNAL_REGULAR_OUTBOUND"
        case externalInbound = "EXTERNAL_INBOUND"
        case externalOutbound = "EXTERNAL_OUTBOUND"
    }

    public let id: UUID
    public let amount: Decimal
    public let direction: Direction
    public let created: Date
    public let narrative: String
    public let source: Source
}
