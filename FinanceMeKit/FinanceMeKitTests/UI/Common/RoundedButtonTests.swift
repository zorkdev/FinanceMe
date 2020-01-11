import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class RoundedButtonTests: XCTestCase {
    func testView() {
        assert(view: RoundedButton("") {}, previews: RoundedButtonPreviews.self)
        RoundedButtonPreviews.action()
    }
}
