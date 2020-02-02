import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class IntegrationTestCase: AsyncTestCase {
    var appState: AppState!

    let credentials: Credentials = {
        loadFromBundle(model: Credentials.self, resource: "TestUser", extension: "json")
    }()

    let session: Session = {
        loadFromBundle(model: Session.self, resource: "TestSession", extension: "json")
    }()

    override func setUp() {
        super.setUp()
        appState = AppState()
        _ = appState.sessionService.save(session: session)
    }

    override func tearDown() {
        super.tearDown()
        appState.dataService.removeAll()
    }
}

private extension IntegrationTestCase {
    static func loadFromBundle<T: Decodable>(model: T.Type,
                                             resource: String,
                                             extension: String) -> T {
        let bundle = Bundle(for: Self.self)
        guard let configURL = bundle.url(forResource: resource, withExtension: `extension`),
            let data = try? Data(contentsOf: configURL),
            let model = try? T(from: data) else { preconditionFailure() }
        return model
    }
}
