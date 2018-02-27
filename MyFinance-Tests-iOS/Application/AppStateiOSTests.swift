import LocalAuthentication
@testable import MyFinance_iOS

class AppStateiOSTests: XCTestCase {

    func testInit() {
        let appState = AppStateiOS()

        XCTAssertTrue(appState.networkService is NetworkService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
        XCTAssertTrue(appState.watchService is WatchService)
        XCTAssertTrue(appState.laContext is LAContext)
        XCTAssertTrue(appState.navigator is Navigator)
    }

}
