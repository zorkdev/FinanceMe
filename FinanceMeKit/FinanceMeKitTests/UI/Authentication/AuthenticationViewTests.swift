import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class AuthenticationViewTests: XCTestCase {
    func testView() {
        assert(view: AuthenticationView(appState: MockAppState()), previews: AuthenticationViewPreviews.self)
    }
}
