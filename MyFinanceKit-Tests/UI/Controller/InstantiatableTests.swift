@testable import MyFinanceKit

class InstantiatableTests: XCTestCase {
    func testInstantiate_Success() {
        _ = TestViewController.instantiate()
    }
}
