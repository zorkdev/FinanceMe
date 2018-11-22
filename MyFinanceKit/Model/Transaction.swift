public enum TransactionDirection: String, JSONCodable, Hashable {

    case none = "NONE"
    case outbound = "OUTBOUND"
    case inbound = "INBOUND"

}

public enum TransactionSource: String, JSONCodable, Hashable {

    case directCredit = "DIRECT_CREDIT"
    case directDebit = "DIRECT_DEBIT"
    case directDebitDispute = "DIRECT_DEBIT_DISPUTE"
    case internalTransfer = "INTERNAL_TRANSFER"
    case masterCard = "MASTER_CARD"
    case fasterPaymentsIn = "FASTER_PAYMENTS_IN"
    case fasterPaymentsOut = "FASTER_PAYMENTS_OUT"
    case fasterPaymentsReversal = "FASTER_PAYMENTS_REVERSAL"
    case stripeFunding = "STRIPE_FUNDING"
    case interestPayment = "INTEREST_PAYMENT"
    case nostroDeposit = "NOSTRO_DEPOSIT"
    case overdraft = "OVERDRAFT"
    case externalRegularInbound = "EXTERNAL_REGULAR_INBOUND"
    case externalRegularOutbound = "EXTERNAL_REGULAR_OUTBOUND"
    case externalInbound = "EXTERNAL_INBOUND"
    case externalOutbound = "EXTERNAL_OUTBOUND"

    public static let externalValues: [TransactionSource] = [.externalOutbound,
                                                             .externalInbound,
                                                             .externalRegularOutbound,
                                                             .externalRegularInbound]

    public var displayString: String {
        switch self {
        case .externalOutbound: return "Outgoing"
        case .externalInbound: return "Incoming"
        case .externalRegularOutbound: return "Regular Outgoing"
        case .externalRegularInbound: return "Regular Incoming"
        default: return rawValue
        }
    }

    public var direction: TransactionDirection {
        switch self {
        case .internalTransfer,
             .fasterPaymentsReversal:
            return .none

        case .directDebit,
             .directDebitDispute,
             .masterCard,
             .fasterPaymentsOut,
             .overdraft,
             .externalOutbound,
             .externalRegularOutbound:
            return .outbound

        case .directCredit,
             .fasterPaymentsIn,
             .stripeFunding,
             .interestPayment,
             .nostroDeposit,
             .externalInbound,
             .externalRegularInbound:
            return .inbound
        }
    }

}

extension TransactionSource: Describable {

    public var description: String { return displayString }

}

public struct Transaction: Storeable, Hashable {

    public let id: String?
    public var amount: Double
    public var direction: TransactionDirection
    public var created: Date
    public var narrative: String
    public var source: TransactionSource

    public init(id: String? = nil,
                amount: Double,
                direction: TransactionDirection,
                created: Date,
                narrative: String,
                source: TransactionSource) {
        self.id = id
        self.amount = amount
        self.direction = direction
        self.created = created
        self.narrative = narrative
        self.source = source
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        amount = try container.decode(Double.self, forKey: .amount)
        direction = try container.decode(TransactionDirection.self, forKey: .direction)
        created = try container.decode(Date.self, forKey: .created)
        narrative = try container.decode(String.self, forKey: .narrative)
        source = (try container.decodeIfPresent(TransactionSource.self, forKey: .source)) ?? .fasterPaymentsOut
    }

}

struct TransactionList: JSONCodable, Equatable {

    let transactions: [Transaction]

}
