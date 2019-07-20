@testable import MyFinanceKit

class AppStateTests: XCTestCase {
    func testInit() {
        let appState = AppState()

        XCTAssertTrue(appState.networkService is NetworkService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
        XCTAssertTrue(appState.configService is ConfigDefaultService)
    }

    func testInitWithParameters() {
        let appState = AppState(networkService: MockNetworkService(),
                                dataService: MockDataService(),
                                configService: MockConfigService(),
                                sessionService: MockSessionService())

        XCTAssertTrue(appState.networkService is MockNetworkService)
        XCTAssertTrue(appState.dataService is MockDataService)
        XCTAssertTrue(appState.configService is MockConfigService)
        XCTAssertTrue(appState.sessionService is MockSessionService)
    }
}
