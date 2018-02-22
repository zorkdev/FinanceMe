@testable import MyFinanceKit

class ExternalTransactionsBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
    }

    func testGetExternalTransactions() {
        let newExpectation = expectation(description: "External Transactions fetched")

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

        mockNetworkService.returnJSONDecodableValue = expectedTransactions

        let externalTransactionsBusinessLogic = ExternalTransactionsBusinessLogic(networkService: mockNetworkService)

        _ = externalTransactionsBusinessLogic.getExternalTransactions(fromTo: expectedFromTo).done { transactions in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.transactions))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.parameters as? FromToParameters, expectedFromTo)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(transactions, expectedTransactions)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
