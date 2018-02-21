@testable import MyFinanceKit

class AppStateTests: XCTestCase {

    func testInit() {
        let appState = AppState()

        XCTAssertTrue(appState.networkService is NetworkService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
    }

}
