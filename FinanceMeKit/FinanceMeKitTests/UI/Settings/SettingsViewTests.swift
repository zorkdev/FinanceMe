import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class SettingsViewTests: XCTestCase {
    func testView() {
        assert(view: SettingsView(appState: MockAppState()), previews: SettingsViewPreviews.self)
    }
}
