@testable import MyFinanceKit

class TableViewCell: UITableViewCell {}

class UITableViewCellExtensionsTests: XCTestCase {

    func testNib() {
        XCTAssertNoThrow(TableViewCell.nib)
    }

}
