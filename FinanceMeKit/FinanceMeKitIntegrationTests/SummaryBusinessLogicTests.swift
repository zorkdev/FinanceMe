import XCTest
@testable import FinanceMeKit

class SummaryBusinessLogicTests: IntegrationTestCase {
    func testGetSummary() {
        appState.summaryBusinessLogic.getSummary().assertSuccess(self) {}
        appState.summaryBusinessLogic.summary.assertSuccess(self) { XCTAssertNotNil($0) }
    }
}
