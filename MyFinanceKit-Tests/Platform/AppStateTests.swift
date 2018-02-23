@testable import MyFinanceKit

class AppStateTests: XCTestCase {

    func testInit() {
        let appState = AppState()

        XCTAssertTrue(appState.networkService is NetworkService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
    }

    func testInitWithParameters() {
        let appState = AppState(networkService: MockNetworkService(),
                                dataService: MockDataService())

        XCTAssertTrue(appState.networkService is MockNetworkService)
        XCTAssertTrue(appState.dataService is MockDataService)
    }

}
