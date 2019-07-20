@testable import MyFinanceKit

class TransactionTests: XCTestCase {
    func testDecodeTransaction() {
        let jsonData =
        """
        {
            "amount" : 10.30,
            "source" : "FASTER_PAYMENTS_IN",
            "id" : "id",
            "created" : "2018-01-01T00:00:00.000Z",
            "direction" : "INBOUND",
            "currency" : "GBP",
            "balance" : 100,
            "narrative" : "Test"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Transaction(data: jsonData))
    }

    func testDecodeTransactionWithNullSource() {
        let jsonData =
            """
        {
            "amount" : 10.30,
            "id" : "id",
            "created" : "2018-01-01T00:00:00.000Z",
            "direction" : "INBOUND",
            "currency" : "GBP",
            "balance" : 100,
            "narrative" : "Test"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Transaction(data: jsonData))
    }

    func testEncodeTransaction() {
        let transaction = Factory.makeTransaction()

        XCTAssertNotNil(transaction.encoded())
    }

    func testDecodeTransactionList() {
        let jsonData =
        """
        {
            "transactions": [
                {
                    "amount" : 10.30,
                    "source" : "FASTER_PAYMENTS_IN",
                    "id" : "id",
                    "created" : "2018-01-01T00:00:00.000Z",
                    "direction" : "INBOUND",
                    "currency" : "GBP",
                    "balance" : 100,
                    "narrative" : "Test"
                }
            ]
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(TransactionList(data: jsonData))
    }

    func testEncodeTransactionList() {
        let transaction = Factory.makeTransaction()

        let transactionList = TransactionList(transactions: [transaction])

        XCTAssertNotNil(transactionList.encoded())
    }

    func testTransactionSourceDirection() {
        XCTAssertEqual(TransactionSource.externalInbound.direction, TransactionDirection.inbound)
        XCTAssertEqual(TransactionSource.fasterPaymentsReversal.direction, TransactionDirection.none)
        XCTAssertEqual(TransactionSource.masterCard.direction, TransactionDirection.outbound)
    }

    func testTransactionSourceDisplayString() {
        XCTAssertEqual(TransactionSource.externalOutbound.displayString, "Outgoing")
        XCTAssertEqual(TransactionSource.externalInbound.displayString, "Incoming")
        XCTAssertEqual(TransactionSource.externalRegularOutbound.displayString, "Regular Outgoing")
        XCTAssertEqual(TransactionSource.externalRegularInbound.displayString, "Regular Incoming")
        XCTAssertEqual(TransactionSource.masterCard.displayString, "MASTER_CARD")
    }

    func testTransactionHashValue() {
        let transaction1 = Factory.makeTransaction()

        var transaction2 = Factory.makeTransaction()
        transaction2.created = transaction1.created

        var transaction3 = Factory.makeTransaction()
        transaction3.amount = 1
        transaction3.created = transaction1.created

        XCTAssertEqual(transaction1.hashValue, transaction2.hashValue)
        XCTAssertNotEqual(transaction1.hashValue, transaction3.hashValue)
    }

    func testTransactionSourceDescription() {
        for source in TransactionSource.externalValues {
            XCTAssertEqual(source.description, source.displayString)
        }
    }
}
