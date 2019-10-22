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

    func testFetchTransactions() {
        let expectedValue = [Transaction.stub]
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.fetchTransactions()

        waitForEvent {}

        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
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

    func testGetTransactions_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.getTransactions().assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, []) }
    }

    func testCreate_Success() {
        let expectedValue = Transaction.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())
        dataService.loadReturnValues = [[expectedValue]]

        businessLogic.create(transaction: expectedValue).assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .transactions)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .post)
            XCTAssertEqual(self.networkService.lastPerformParams?.body as? Transaction, expectedValue)
            XCTAssertEqual(self.dataService.savedValues.first as? [Transaction], [expectedValue, expectedValue])
        }

        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, [expectedValue, expectedValue]) }
    }

    func testCreate_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.create(transaction: Transaction.stub).assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, []) }
    }

    func testUpdate_Success() {
        let expectedValue = Transaction.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())
        dataService.loadReturnValues = [[expectedValue]]

        businessLogic.update(transaction: expectedValue).assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .transaction(expectedValue.id))
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .put)
            XCTAssertEqual(self.networkService.lastPerformParams?.body as? Transaction, expectedValue)
            XCTAssertEqual(self.dataService.savedValues.first as? [Transaction], [expectedValue])
        }

        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, [expectedValue]) }
    }

    func testUpdate_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.update(transaction: Transaction.stub).assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, []) }
    }

    func testDelete_Success() {
        let expectedValue = Transaction.stub
        networkService.performReturnValues = [.success(Data())]
        dataService.saveReturnValue = .success(())
        dataService.loadReturnValues = [[expectedValue]]

        businessLogic.delete(transaction: expectedValue).assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .transaction(expectedValue.id))
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .delete)
            XCTAssertNil(self.networkService.lastPerformParams?.body)
            XCTAssertEqual(self.dataService.savedValues.first as? [Transaction], [])
        }

        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, []) }
    }

    func testDelete_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.delete(transaction: Transaction.stub).assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.transactions.assertSuccess(self) { XCTAssertEqual($0, []) }
    }

    func testReconcile_Success() {
        networkService.performReturnValues = [.success(Data())]

        businessLogic.reconcile().assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .reconcile)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .post)
            XCTAssertNil(self.networkService.lastPerformParams?.body)
        }
    }

    func testReconcile_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.reconcile().assertFailure(self) { XCTAssertTrue($0 is TestError) }
    }

    func testStub() {
        let stub = Stub.StubTransactionBusinessLogic()
        stub.fetchTransactions()
        _ = stub.getTransactions()
        _ = stub.create(transaction: Transaction.stub)
        _ = stub.update(transaction: Transaction.stub)
        _ = stub.delete(transaction: Transaction.stub)
        _ = stub.reconcile()
    }
}
