import SwiftKeychainWrapper
@testable import MyFinanceKit

class DataServiceTests: XCTestCase {

    struct StubModel: Storeable, Equatable {
        let variable: String
    }

    var mockDataService = MockDataService()
    let keychainDataService = KeychainDataService(configService: ConfigDefaultService())
    let userDefaultsDataService = UserDefaultsDataService()

    override func tearDown() {
        super.tearDown()

        mockDataService = MockDataService()
        _ = keychainDataService.keychain.removeAllKeys()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testStoreableSave_Success() {
        let stubModel = StubModel(variable: "value")

        stubModel.save(dataService: mockDataService)

        XCTAssertFalse(mockDataService.savedValues.isEmpty)
        XCTAssertTrue(mockDataService.savedValues
            .contains(where: { ($0 as? StubModel) == stubModel }) == true)
        XCTAssertEqual(mockDataService.lastSavedKey, "StubModel")
    }

    func testStoreableLoad_Success() {
        let stubModel = StubModel(variable: "value")
        mockDataService.loadReturnValues = [stubModel]

        let loadedItem = StubModel.load(dataService: mockDataService)

        XCTAssertNotNil(loadedItem)
        XCTAssertEqual(loadedItem!, stubModel)
        XCTAssertEqual(mockDataService.lastLoadedKey, "StubModel")
    }

    func testStoreableAll_Success() {
        let stubModels = [StubModel(variable: "value")]
        mockDataService.loadReturnValues = [stubModels]

        let loadedItem = StubModel.all(dataService: mockDataService)

        XCTAssertNotNil(loadedItem)
        XCTAssertEqual(loadedItem, stubModels)
        XCTAssertEqual(mockDataService.lastLoadedKey, "Array<StubModel>")
    }

    func testStoreableAllEmpty_Success() {
        mockDataService.loadReturnValues = []

        let loadedItem = StubModel.all(dataService: mockDataService)

        XCTAssertNotNil(loadedItem)
        XCTAssertEqual(loadedItem, [])
        XCTAssertEqual(mockDataService.lastLoadedKey, "Array<StubModel>")
    }

    func testKeychainSaveAndLoad_Success() {
        let key = "key"
        let stubModel = StubModel(variable: "value")

        let saveStatus = keychainDataService.save(value: stubModel, key: key)
        let retrievedValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertEqual(saveStatus, .success)
        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, stubModel)
    }

    func testKeychainSave_Failure() {
        let key = "key"
        let nan = Double.nan

        let saveStatus = keychainDataService.save(value: nan, key: key)

        XCTAssertEqual(saveStatus, .failure)
    }

    func testKeychainLoad_Failure() {
        let key = "nonExistantKey"

        let loadedItem: StubModel? = keychainDataService.load(key: key)

        XCTAssertNil(loadedItem)
    }

    func testUserDefaultsSaveAndLoad_Success() {
        let key = "key"
        let stubModel = StubModel(variable: "value")

        let saveStatus = userDefaultsDataService.save(value: stubModel, key: key)
        let retrievedValue: StubModel? = userDefaultsDataService.load(key: key)

        XCTAssertEqual(saveStatus, .success)
        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, stubModel)
    }

    func testUserDefaultsSave_Failure() {
        let key = "key"
        let nan = Double.nan

        let saveStatus = userDefaultsDataService.save(value: nan, key: key)

        XCTAssertEqual(saveStatus, .failure)
    }

    func testUserDefaultsLoad_Failure() {
        let key = "nonExistantKey"

        let loadedItem: StubModel? = userDefaultsDataService.load(key: key)

        XCTAssertNil(loadedItem)
    }

}
