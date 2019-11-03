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
        #if os(iOS) || os(macOS)
        dataService.removeAll()
        #endif
    }

    func testSaveAndLoad_Success() throws {
        let key = "key"
        let model = Model(variable: "value")

        try dataService.save(value: model, key: key).get()
        let retrievedValue: Model? = dataService.load(key: key)

        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, model)
    }

    func testUpdate() throws {
        let key = "key"
        let model1 = Model(variable: "value")

        try dataService.save(value: model1, key: key).get()
        let retrievedValue: Model? = dataService.load(key: key)

        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, model1)

        let model2 = Model(variable: "anotherValue")

        try dataService.save(value: model2, key: key).get()
        let retrievedAgainValue: Model? = dataService.load(key: key)

        XCTAssertNotNil(retrievedAgainValue)
        XCTAssertEqual(retrievedAgainValue!, model2)
    }

    func testSave_Failure() {
        let key = "key"
        let nan = Double.nan

        XCTAssertThrowsError(try dataService.save(value: nan, key: key).get())
    }

    func testLoad_Failure() {
        let key = "nonExistantKey"

        let loadedItem: Model? = dataService.load(key: key)

        XCTAssertNil(loadedItem)
    }

    #if os(iOS) || os(macOS)
    func testRemoveAll() throws {
        let key = "key"
        let model = Model(variable: "value")

        try dataService.save(value: model, key: key).get()
        let retrievedValue: Model? = dataService.load(key: key)

        XCTAssertNotNil(retrievedValue)

        dataService.removeAll()
        let retrievedAgainValue: Model? = dataService.load(key: key)

        XCTAssertNil(retrievedAgainValue)
    }
    #endif

    func testStub() {
        let stub = Stub.StubDataService()
        let _: Int? = stub.load(key: "")
        _ = stub.save(value: 1, key: "")
        #if os(iOS) || os(macOS)
        stub.removeAll()
        #endif
    }
}
