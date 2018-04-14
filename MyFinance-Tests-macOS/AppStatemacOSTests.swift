import XCTest
import MyFinanceKit
@testable import MyFinance_macOS

class AppStatemacOSTests: XCTestCase {

    func testInit() {
        let appState = AppStatemacOS()

        XCTAssertTrue(appState.networkService is NetworkService)
        XCTAssertTrue(appState.dataService is KeychainDataService)
        XCTAssertTrue(appState.sessionService is SessionFileService)
    }

}
