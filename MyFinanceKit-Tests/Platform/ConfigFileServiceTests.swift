@testable import MyFinanceKit

class ConfigFileServiceTests: XCTestCase {

    var mockFatalError = MockFatalError()

    override func tearDown() {
        super.tearDown()

        mockFatalError = MockFatalError()
    }

    func testInit_Success() {
        XCTAssertNotNil(ConfigFileService(fatalErrorable: mockFatalError))
    }

    func testInit_Failure() {
        let path = Bundle(for: ConfigFileService.self).path(forResource: "config", ofType: "json")!
        let configData = FileManager.default.contents(atPath: path)!
        try? FileManager.default.removeItem(atPath: path)

        XCTAssertNil(ConfigFileService(fatalErrorable: mockFatalError))
        XCTAssertTrue(mockFatalError.didCallFatalError)

        FileManager.default.createFile(atPath: path, contents: configData, attributes: nil)
    }

}
