import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class DefaultSessionServiceTests: XCTestCase {
    var dataService: MockDataService!
    var sessionService: DefaultSessionService!

    override func setUp() {
        super.setUp()
        dataService = MockDataService()
        sessionService = DefaultSessionService(dataService: dataService)
    }

    func testGetSession_Success() {
        let expectedSession = Session.stub
        dataService.loadReturnValues = [expectedSession, expectedSession]

        XCTAssertEqual(sessionService.session, expectedSession)
        XCTAssertTrue(sessionService.hasSession)
    }

    func testGetSession_Failure() {
        XCTAssertNil(sessionService.session)
        XCTAssertFalse(sessionService.hasSession)
    }

    func testSaveSession() {
        let expectedSession = Session.stub

        sessionService.save(session: expectedSession)

        XCTAssertEqual(dataService.savedValues.first as? Session, expectedSession)
    }

    func testLogOut() {
        sessionService.logOut()

        XCTAssertTrue(dataService.didCallRemoveAll)
    }
}
