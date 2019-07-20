@testable import MyFinanceKit

class SessionServiceTests: XCTestCase {
    var mockDataService: MockDataService!

    override func setUp() {
        super.setUp()

        mockDataService = MockDataService()
    }

    func testGetSession_Success() {
        let expectedSession = Factory.makeSession()
        mockDataService.loadReturnValues = [expectedSession, expectedSession]

        let sessionDefaultService = SessionDefaultService(dataService: mockDataService)

        XCTAssertEqual(sessionDefaultService.getSession(), expectedSession)
        XCTAssertTrue(sessionDefaultService.hasSession)
    }

    func testGetSession_Failure() {
        let sessionDefaultService = SessionDefaultService(dataService: mockDataService)

        XCTAssertNil(sessionDefaultService.getSession())
        XCTAssertFalse(sessionDefaultService.hasSession)
    }

    func testSaveSession() {
        let expectedSession = Factory.makeSession()

        let sessionDefaultService = SessionDefaultService(dataService: mockDataService)

        sessionDefaultService.save(session: expectedSession)

        XCTAssertEqual(mockDataService.savedValues.first as? Session, expectedSession)
    }

    func testInitLoadFromBundle() {
        _ = SessionFileService(dataService: mockDataService)

        XCTAssertTrue(mockDataService.savedValues.first is Session)
    }

    func testInitLoadFromDataService() {
        mockDataService.loadReturnValues = [Factory.makeSession()]

        _ = SessionFileService(dataService: mockDataService)

        XCTAssertTrue(mockDataService.savedValues.isEmpty)
    }
}
