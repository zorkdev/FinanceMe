import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class TransactionBusinessLogicTests: XCTestCase {
    var networkService: MockNetworkService!
    var dataService: MockDataService!
    var businessLogic: TransactionBusinessLogic!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        dataService = MockDataService()
        businessLogic = TransactionBusinessLogic(networkService: networkService, dataService: dataService)
    }

    func testGetTransactions_Success() {
        let expectedValue = [Transaction.stub]
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.getTransactions().assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .transactions)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .get)
            XCTAssertNil(self.networkService.lastPerformParams?.body)
            XCTAssertEqual(self.dataService.savedValues.first as? [Transaction], expectedValue)
        }

        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
    }

    func testGetUser_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.getTransactions().assertFailure(self) { error in
            XCTAssertTrue(error is TestError)
        }

        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, []) }
    }

    func testStub() {
        let stub = Stub.StubTransactionBusinessLogic()
        _ = stub.getTransactions()
    }
}
