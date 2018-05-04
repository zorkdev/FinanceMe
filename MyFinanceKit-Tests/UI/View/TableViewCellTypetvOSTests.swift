@testable import MyFinanceKit

class TableViewCelltvOS: UITableViewCell {}

class TableViewCellTypeTests: XCTestCase {

    func testNib() {
        XCTAssertNoThrow(TableViewCelltvOS.nib)
        XCTAssertEqual(TableViewCelltvOS.reuseIdentifier, "TableViewCelltvOS")
    }

}
