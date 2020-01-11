import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class SummaryBusinessLogicTests: AsyncTestCase {
    var networkService: MockNetworkService!
    var dataService: MockDataService!
    var businessLogic: SummaryBusinessLogic!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        dataService = MockDataService()
        businessLogic = SummaryBusinessLogic(networkService: networkService, dataService: dataService)
    }

    func testFetchSummary() {
        let expectedValue = Summary.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.fetchSummary()

        waitForEvent {}

        businessLogic.summary.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
    }

    func testGetSummary_Success() {
        let expectedValue = Summary.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.getSummary().assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .summary)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .get)
            XCTAssertNil(self.networkService.lastPerformParams?.body)
            XCTAssertEqual(self.dataService.savedValues.first as? Summary, expectedValue)
        }

        businessLogic.summary.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
    }

    func testGetSummary_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.getSummary().assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.summary.assertSuccess(self) { XCTAssertNil($0) }
    }

    func testStub() {
        let stub = Stub.StubSummaryBusinessLogic()
        stub.fetchSummary()
        _ = stub.getSummary()
    }
}
