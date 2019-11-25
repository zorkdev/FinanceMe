// swiftlint:disable unused_declaration
struct Transaction: Storeable, Identifiable, Equatable {
    enum Direction: String, Codable {
        case outbound = "OUTBOUND"
        case inbound = "INBOUND"
    }

    enum Source: String, Codable, CaseIterable {
        case externalOutbound = "EXTERNAL_OUTBOUND"
        case externalInbound = "EXTERNAL_INBOUND"
        case externalRegularOutbound = "EXTERNAL_REGULAR_OUTBOUND"
        case externalRegularInbound = "EXTERNAL_REGULAR_INBOUND"
        case externalSavings = "EXTERNAL_SAVINGS"

        var displayString: String {
            switch self {
            case .externalOutbound: return "Outgoing"
            case .externalInbound: return "Incoming"
            case .externalRegularOutbound: return "Regular Outgoing"
            case .externalRegularInbound: return "Regular Incoming"
            case .externalSavings: return "Savings"
            }
        }
    }

    let id: UUID
    let amount: Decimal
    let direction: Direction
    let created: Date
    let narrative: String
    let source: Source
}
