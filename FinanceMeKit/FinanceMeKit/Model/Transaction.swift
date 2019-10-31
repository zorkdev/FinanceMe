public struct Transaction: Storeable, Identifiable, Equatable {
    public enum Direction: String, Codable {
        case outbound = "OUTBOUND"
        case inbound = "INBOUND"
    }

    public enum Source: String, Codable, CaseIterable {
        case externalOutbound = "EXTERNAL_OUTBOUND"
        case externalInbound = "EXTERNAL_INBOUND"
        case externalRegularOutbound = "EXTERNAL_REGULAR_OUTBOUND"
        case externalRegularInbound = "EXTERNAL_REGULAR_INBOUND"

        public var displayString: String {
            switch self {
            case .externalOutbound: return "Outgoing"
            case .externalInbound: return "Incoming"
            case .externalRegularOutbound: return "Regular Outgoing"
            case .externalRegularInbound: return "Regular Incoming"
            }
        }
    }

    // swiftlint:disable unused_declaration
    public let id: UUID
    public let amount: Decimal
    public let direction: Direction
    public let created: Date
    public let narrative: String
    public let source: Source
}
