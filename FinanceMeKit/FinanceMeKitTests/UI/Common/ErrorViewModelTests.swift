import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class ErrorViewModelTests: XCTestCase {
    var viewModel: ErrorViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ErrorViewModel()
    }

    func testNilError() {
        XCTAssertNil(viewModel.icon)
        XCTAssertNil(viewModel.description)
    }

    func testSomeError() {
        viewModel.error = TestError()

        XCTAssertNotNil(viewModel.icon)
        XCTAssertEqual(viewModel.description, "Test Error")
    }
}