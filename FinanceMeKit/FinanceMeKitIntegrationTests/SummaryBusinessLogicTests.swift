import XCTest
@testable import FinanceMeKit

final class SummaryBusinessLogicTests: IntegrationTestCase {
    func testGetSummary() {
        appState.summaryBusinessLogic.getSummary().assertSuccess(self, once: false) {}
        appState.summaryBusinessLogic.summary.assertSuccess(self) { XCTAssertNotNil($0) }
    }
}
