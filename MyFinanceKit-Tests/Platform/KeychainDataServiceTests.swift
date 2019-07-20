@testable import MyFinanceKit

class KeychainDataServiceTests: XCTestCase {
    struct StubModel: Storeable, Equatable {
        let variable: String
    }

    var keychainDataService: KeychainDataService!

    override func setUp() {
        super.setUp()

        keychainDataService = KeychainDataService(configService: ConfigDefaultService())
    }

    override func tearDown() {
        super.tearDown()

        keychainDataService.removeAll()
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

    func testKeychainUpdate() {
        let key = "key"
        let stubModel1 = StubModel(variable: "value")

        let saveStatus = keychainDataService.save(value: stubModel1, key: key)
        let retrievedValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertEqual(saveStatus, .success)
        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, stubModel1)

        let stubModel2 = StubModel(variable: "anotherValue")

        let saveAgainStatus = keychainDataService.save(value: stubModel2, key: key)
        let retrievedAgainValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertEqual(saveAgainStatus, .success)
        XCTAssertNotNil(retrievedAgainValue)
        XCTAssertEqual(retrievedAgainValue!, stubModel2)
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

    func testKeychainDelete() {
        let key = "key"
        let stubModel = StubModel(variable: "value")

        let saveStatus = keychainDataService.save(value: stubModel, key: key)
        let retrievedValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertEqual(saveStatus, .success)
        XCTAssertNotNil(retrievedValue)

        keychainDataService.delete(key: key)
        let retrievedAgainValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertNil(retrievedAgainValue)
    }

    func testKeychainRemoveAll() {
        let key = "key"
        let stubModel = StubModel(variable: "value")

        let saveStatus = keychainDataService.save(value: stubModel, key: key)
        let retrievedValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertEqual(saveStatus, .success)
        XCTAssertNotNil(retrievedValue)

        keychainDataService.removeAll()
        let retrievedAgainValue: StubModel? = keychainDataService.load(key: key)

        XCTAssertNil(retrievedAgainValue)
    }
}
