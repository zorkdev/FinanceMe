import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class StoreableTests: XCTestCase {
    struct Model: Storeable, Equatable {
        let variable: String
    }

    var dataService: MockDataService!

    override func setUp() {
        super.setUp()
        dataService = MockDataService()
    }

    func testSave_Success() {
        let model = Model(variable: "value")

        model.save(dataService: dataService)

        XCTAssertFalse(dataService.savedValues.isEmpty)
        XCTAssertTrue(dataService.savedValues.contains { ($0 as? Model) == model })
        XCTAssertEqual(dataService.lastSaveKey, "Model")
    }

    func testLoad_Success() {
        let model = Model(variable: "value")
        dataService.loadReturnValues = [model]

        let loadedItem = Model.load(dataService: dataService)

        XCTAssertNotNil(loadedItem)
        XCTAssertEqual(loadedItem!, model)
        XCTAssertEqual(dataService.lastLoadKey, "Model")
    }
}
