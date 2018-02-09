public enum TransactionDirection: String, JSONCodable {

    case none = "NONE"
    case outbound = "OUTBOUND"
    case inbound = "INBOUND"

}

public enum TransactionSource: String, JSONCodable {

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

public struct Transaction: Storeable {

    public let id: String?
    public let currency: String
    public let amount: Double
    public let direction: TransactionDirection
    public let created: Date
    public let narrative: String
    public let source: TransactionSource
    public let balance: Double

    public init(id: String? = nil,
                currency: String = "GBP",
                amount: Double,
                direction: TransactionDirection,
                created: Date,
                narrative: String,
                source: TransactionSource,
                balance: Double = 0.0) {
        self.id = id
        self.currency = currency
        self.amount = amount
        self.direction = direction
        self.created = created
        self.narrative = narrative
        self.source = source
        self.balance = balance
    }

}

struct TransactionList: JSONCodable {

    let transactions: [Transaction]

}
