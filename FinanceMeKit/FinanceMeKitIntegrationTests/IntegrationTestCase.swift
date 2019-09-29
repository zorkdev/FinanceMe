import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class IntegrationTestCase: XCTestCase {
    var appState: AppState!

    let credentials: Credentials = {
        let bundle = Bundle(for: IntegrationTestCase.self)
        guard let configURL = bundle.url(forResource: "config", withExtension: "json"),
            let data = try? Data(contentsOf: configURL),
            let credentials = try? Credentials(from: data) else { preconditionFailure() }
        return credentials
    }()

    override func setUp() {
        super.setUp()
        appState = AppState()
        appState.sessionBusinessLogic.login(credentials: credentials).assertSuccess(self) { _ in }
    }

    override func tearDown() {
        super.tearDown()
        appState.dataService.removeAll()
    }
}
