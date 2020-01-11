import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class AppStateTests: XCTestCase {
    func testInit() {
        let appState = AppState()

        XCTAssertTrue(appState.networkService is DefaultNetworkService)
        XCTAssertTrue(appState.sessionService is DefaultSessionService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
        XCTAssertTrue(appState.loggingService is DefaultLoggingService)
        XCTAssertTrue(appState.configService is DefaultConfigService)
        XCTAssertTrue(appState.sessionBusinessLogic is SessionBusinessLogic)
        XCTAssertTrue(appState.userBusinessLogic is UserBusinessLogic)
        XCTAssertTrue(appState.transactionBusinessLogic is TransactionBusinessLogic)
        XCTAssertTrue(appState.summaryBusinessLogic is SummaryBusinessLogic)

        _ = AppState.stub
    }
}
