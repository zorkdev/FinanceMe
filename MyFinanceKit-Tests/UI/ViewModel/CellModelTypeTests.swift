@testable import MyFinanceKit

class CellModelTypeTests: XCTestCase {

    func testCellModelWrapper() {

        class TestCellModel: CellModelType {
            static let reuseIdentifier = "TestCellModel"
            let id = 123
        }

        let cellModel = TestCellModel()
        let wrapper = CellModelWrapper(cellModel)

        XCTAssertEqual(wrapper.hashValue, 123.hashValue)
        XCTAssertEqual(wrapper.wrapped.id, 123)
        XCTAssertEqual(cellModel.wrap, wrapper)
        XCTAssertEqual(cellModel.canEdit, false)
        XCTAssertEqual(TestCellModel.reuseIdentifier, "TestCellModel")
        XCTAssertEqual(TestCellModel.rowHeight, 60)
    }

}
