@testable import MyFinanceKit

class TableViewCelliOS: UITableViewCell {}

class UITableViewCellExtensionsTests: XCTestCase {

    func testNib() {
        XCTAssertNoThrow(TableViewCelliOS.nib)
    }

}
