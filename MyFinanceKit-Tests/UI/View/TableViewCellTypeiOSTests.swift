@testable import MyFinanceKit

class TableViewCelliOS: UITableViewCell {}

class TableViewCellTypeTests: XCTestCase {
    func testNib() {
        XCTAssertNoThrow(TableViewCelliOS.nib)
        XCTAssertEqual(TableViewCelliOS.reuseIdentifier, "TableViewCelliOS")
    }
}
