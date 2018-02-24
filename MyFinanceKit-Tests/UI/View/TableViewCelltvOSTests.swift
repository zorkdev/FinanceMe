@testable import MyFinanceKit

class TableViewCelltvOS: UITableViewCell {}

class UITableViewCellExtensionsTests: XCTestCase {

    func testNib() {
        XCTAssertNoThrow(TableViewCelltvOS.nib)
    }

}
