import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class AppStateTests: XCTestCase {
    func testInit() {
        let appState = AppState(authReason: "Test")

        XCTAssertTrue(appState.networkService is DefaultNetworkService)
        XCTAssertTrue(appState.sessionService is DefaultSessionService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
        XCTAssertTrue(appState.loggingService is DefaultLoggingService)
        XCTAssertTrue(appState.configService is DefaultConfigService)
        XCTAssertTrue(appState.authenticationService is LAContextAuthenticationService)
    }
}
