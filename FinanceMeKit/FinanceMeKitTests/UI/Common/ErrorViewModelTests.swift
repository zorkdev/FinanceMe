import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class ErrorViewModelTests: XCTestCase {
    var viewModel: ErrorViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ErrorViewModel()
    }

    func testNilError() {
        XCTAssertNil(viewModel.icon)
        XCTAssertNil(viewModel.description)
        XCTAssertFalse(viewModel.isError)
    }

    func testSomeError() {
        viewModel.error = TestError()

        XCTAssertNotNil(viewModel.icon)
        XCTAssertEqual(viewModel.description, "Test Error")
        XCTAssertTrue(viewModel.isError)
    }
}
