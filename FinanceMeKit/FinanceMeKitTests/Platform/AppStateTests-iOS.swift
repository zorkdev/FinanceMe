import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class AppStateTests: XCTestCase {
    func testInit() {
        let appState = AppState()

        XCTAssertTrue(appState.networkService is DefaultNetworkService)
        XCTAssertTrue(appState.sessionService is DefaultSessionService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
        XCTAssertTrue(appState.loggingService is DefaultLoggingService)
        XCTAssertTrue(appState.configService is DefaultConfigService)
        XCTAssertTrue(appState.authenticationService is LAContextAuthenticationService)
        XCTAssertTrue(appState.sessionBusinessLogic is SessionBusinessLogic)
        XCTAssertTrue(appState.userBusinessLogic is UserBusinessLogic)
        XCTAssertTrue(appState.transactionBusinessLogic is TransactionBusinessLogic)
        XCTAssertTrue(appState.summaryBusinessLogic is SummaryBusinessLogic)
        XCTAssertTrue(appState.authenticationBusinessLogic is AuthenticationBusinessLogic)

        _ = AppState.stub
    }
}
