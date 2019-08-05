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

    func testInitWithParameters() {
        let appState = AppState(networkService: MockNetworkService(),
                                sessionService: MockSessionService(),
                                dataService: MockDataService(),
                                loggingService: MockLoggingService(),
                                configService: MockConfigService(),
                                authenticationService: MockAuthenticationService())

        XCTAssertTrue(appState.networkService is MockNetworkService)
        XCTAssertTrue(appState.sessionService is MockSessionService)
        XCTAssertTrue(appState.dataService is MockDataService)
        XCTAssertTrue(appState.loggingService is MockLoggingService)
        XCTAssertTrue(appState.configService is MockConfigService)
        XCTAssertTrue(appState.authenticationService is MockAuthenticationService)
    }
}
