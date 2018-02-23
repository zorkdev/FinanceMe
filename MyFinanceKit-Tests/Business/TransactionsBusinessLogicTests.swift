@testable import MyFinanceKit

class TransactionsBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
    }

    func testGetTransactions() {
        let newExpectation = expectation(description: "Transactions fetched")

        let now = Date()
        let dayBefore = now.dayBefore

        let expectedFromTo = FromToParameters(from: dayBefore, to: now)

        let expectedTransactions = [Transaction(id: "id",
                                                currency: "GBP",
                                                amount: 10.30,
                                                direction: .inbound,
                                                created: Date(),
                                                narrative: "Test",
                                                source: .fasterPaymentsIn,
                                                balance: 100)]

        let halResponse = HALResponse(embedded: TransactionList(transactions: expectedTransactions))

        mockNetworkService.returnJSONDecodableValues = [halResponse]

        let transactionsBusinessLogic = TransactionsBusinessLogic(networkService: mockNetworkService)

        _ = transactionsBusinessLogic.getTransactions(fromTo: expectedFromTo).done { transactions in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .starling(.transactions))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.parameters as? FromToParameters, expectedFromTo)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(transactions, expectedTransactions)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
