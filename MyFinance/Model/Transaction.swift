enum TransactionDirection: String, Codable {

    case none = "NONE"
    case outbound = "OUTBOUND"
    case inbound = "INBOUND"

}

enum TransactionSource: String, Codable {

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
    case externelRegularInbound = "EXTERNAL_REGULAR_INBOUND"
    case externalRegularOutbound = "EXTERNAL_REGULAR_OUTBOUND"
    case externalInbound = "EXTERNAL_INBOUND"
    case externalOutbound = "EXTERNAL_OUTBOUND"

}

struct Transaction: Codable {

    let id: String
    let currency: String
    let amount: Double
    let direction: TransactionDirection
    let created: Date
    let narrative: String
    let source: TransactionSource
    let balance: Double

}

struct TransactionList: Codable {

    let transactions: [Transaction]

}
