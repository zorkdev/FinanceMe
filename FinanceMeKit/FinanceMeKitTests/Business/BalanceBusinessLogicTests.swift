import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class BalanceBusinessLogicTests: ServiceClientTestCase {
    var businessLogic: BalanceBusinessLogic!

    override func setUp() {
        super.setUp()
        businessLogic = BalanceBusinessLogic(serviceProvider: appState)
    }

    func testGetBalance_Success() {
        let expectedValue = Balance.stub
        appState.mockNetworkService.performReturnValues = [expectedValue.jsonEncoded()]

        businessLogic.getBalance().assertSuccess(self) { value in
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.api as? StarlingAPI, .balance)
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.method, .get)
            XCTAssertNil(self.appState.mockNetworkService.lastPerformParams?.body)
            XCTAssertEqual(self.appState.mockDataService.savedValues.first as? Balance, expectedValue)
            XCTAssertEqual(value, expectedValue)
        }
    }

    func testGetBalance_Failure() {
        appState.mockNetworkService.performReturnValues = [.failure(TestError())]

        businessLogic.getBalance().assertFailure(self) { error in
            XCTAssertTrue(error is TestError)
        }
    }
}
