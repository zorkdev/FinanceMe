import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class LoginViewTests: XCTestCase {
    func testView() {
        assert(view: LoginView(appState: MockAppState()), previews: LoginViewPreviews.self)
    }
}
