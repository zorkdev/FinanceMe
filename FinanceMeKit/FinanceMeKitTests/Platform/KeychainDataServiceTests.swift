import XCTest
@testable import FinanceMeKit

class KeychainDataServiceTests: XCTestCase {
    struct Model: Storeable, Equatable {
        let variable: String
    }

    var dataService: KeychainDataService!

    override func setUp() {
        super.setUp()
        dataService = KeychainDataService(configService: DefaultConfigService())
    }

    override func tearDown() {
        super.tearDown()
        dataService.removeAll()
    }

    func testSaveAndLoad_Success() {
        let key = "key"
        let model = Model(variable: "value")

        let saveResult = dataService.save(value: model, key: key)
        let retrievedValue: Model? = dataService.load(key: key)

        guard case .success(()) = saveResult else {
            XCTFail("Save should not have failed.")
            return
        }

        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, model)
    }

    func testUpdate() {
        let key = "key"
        let model1 = Model(variable: "value")

        let saveResult = dataService.save(value: model1, key: key)
        let retrievedValue: Model? = dataService.load(key: key)

        guard case .success(()) = saveResult else {
            XCTFail("Save should not have failed.")
            return
        }

        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, model1)

        let model2 = Model(variable: "anotherValue")

        let saveAgainResult = dataService.save(value: model2, key: key)
        let retrievedAgainValue: Model? = dataService.load(key: key)

        guard case .success(()) = saveAgainResult else {
            XCTFail("Save should not have failed.")
            return
        }

        XCTAssertNotNil(retrievedAgainValue)
        XCTAssertEqual(retrievedAgainValue!, model2)
    }

    func testSave_Failure() {
        let key = "key"
        let nan = Double.nan

        let saveResult = dataService.save(value: nan, key: key)

        guard case .failure = saveResult else {
            XCTFail("Save should not have succeeded.")
            return
        }
    }

    func testLoad_Failure() {
        let key = "nonExistantKey"

        let loadedItem: Model? = dataService.load(key: key)

        XCTAssertNil(loadedItem)
    }

    func testRemoveAll() {
        let key = "key"
        let model = Model(variable: "value")

        let saveResult = dataService.save(value: model, key: key)
        let retrievedValue: Model? = dataService.load(key: key)

        guard case .success(()) = saveResult else {
            XCTFail("Save should not have failed.")
            return
        }

        XCTAssertNotNil(retrievedValue)

        dataService.removeAll()
        let retrievedAgainValue: Model? = dataService.load(key: key)

        XCTAssertNil(retrievedAgainValue)
    }
}
