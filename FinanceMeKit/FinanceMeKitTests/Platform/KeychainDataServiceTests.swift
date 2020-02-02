import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class KeychainDataServiceTests: XCTestCase {
    struct Model: Storeable, Equatable {
        let variable: String
    }

    var loggingService: MockLoggingService!
    var dataService: KeychainDataService!

    override func setUp() {
        super.setUp()
        loggingService = MockLoggingService()
        dataService = KeychainDataService(configService: DefaultConfigService(), loggingService: loggingService)
    }

    override func tearDown() {
        super.tearDown()
        dataService.removeAll()
    }

    func testSaveAndLoad_Success() throws {
        let key = "key"
        let model = Model(variable: "value")

        try dataService.save(value: model, key: key).get()
        let retrievedValue: Model? = dataService.load(key: key)

        XCTAssertNotNil(retrievedValue)
        XCTAssertEqual(retrievedValue!, model)
        XCTAssertNil(loggingService.lastLogParams)
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
        XCTAssertNil(loggingService.lastLogParams)
    }

    func testUpdate_Failure() throws {
        let key = "key"
        let data = Data()

        XCTAssertThrowsError(try dataService.update(value: data, key: key).get())
        XCTAssertEqual(loggingService.lastLogParams?.content,
                       "The specified item could not be found in the keychain. (-25300)")
    }

    func testSaveEncoding_Failure() {
        let key = "key"
        let nan = Double.nan

        XCTAssertThrowsError(try dataService.save(value: nan, key: key).get())
        XCTAssertNil(loggingService.lastLogParams)
    }

    func testSaveKeychain_Failure() {
        dataService = KeychainDataService(configService: MockConfigService(), loggingService: loggingService)

        let key = "key"
        let model = Model(variable: "value")

        XCTAssertThrowsError(try dataService.save(value: model, key: key).get())
        XCTAssertEqual(loggingService.lastLogParams?.content, "A required entitlement isn't present. (-34018)")
    }

    func testLoadDecoding_Failure() {
        let key = "nonExistantKey"

        let loadedItem: Model? = dataService.load(key: key)

        XCTAssertNil(loadedItem)
        XCTAssertNil(loggingService.lastLogParams)
    }

    func testLoadKeychain_Failure() {
        dataService = KeychainDataService(configService: MockConfigService(), loggingService: loggingService)
        let key = "nonExistantKey"

        let loadedItem: Model? = dataService.load(key: key)

        XCTAssertNil(loadedItem)
        XCTAssertEqual(loggingService.lastLogParams?.content, "A required entitlement isn't present. (-34018)")
    }

    func testRemoveAll() throws {
        let key = "key"
        let model = Model(variable: "value")

        try dataService.save(value: model, key: key).get()
        let retrievedValue: Model? = dataService.load(key: key)

        XCTAssertNotNil(retrievedValue)

        dataService.removeAll()
        let retrievedAgainValue: Model? = dataService.load(key: key)

        XCTAssertNil(retrievedAgainValue)
        XCTAssertNil(loggingService.lastLogParams)
    }

    func testRemoveAll_Failure() {
        dataService = KeychainDataService(configService: MockConfigService(), loggingService: loggingService)

        dataService.removeAll()

        XCTAssertEqual(loggingService.lastLogParams?.content, "A required entitlement isn't present. (-34018)")
    }

    func testStub() {
        let stub = Stub.StubDataService()
        let _: Int? = stub.load(key: "")
        _ = stub.save(value: 1, key: "")
        stub.removeAll()
    }
}
