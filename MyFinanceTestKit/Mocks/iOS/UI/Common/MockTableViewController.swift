@testable import MyFinance_iOS

class MockTableViewController: TableViewControllerType {

    var didCallUpdateCells = false
    func updateCells() {
        didCallUpdateCells = true
    }

    var lastUpdateCellsValue: TableViewUpdate?
    func updateCells(tableViewUpdate: TableViewUpdate) {
        lastUpdateCellsValue = tableViewUpdate
    }

}
