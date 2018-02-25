@testable import MyFinance_iOS

class AppStateiOSTests: XCTestCase {

    func testInit() {
        let appState = AppStateiOS()

        XCTAssertTrue(appState.networkService is NetworkService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
    }

}
