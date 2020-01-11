import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class DefaultSessionServiceTests: XCTestCase {
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

    func testSaveSession() throws {
        let expectedSession = Session.stub
        dataService.saveReturnValue = .success(())

        try sessionService.save(session: expectedSession).get()

        XCTAssertEqual(dataService.savedValues.first as? Session, expectedSession)
    }

    func testLogOut() {
        sessionService.logOut()

        XCTAssertTrue(dataService.didCallRemoveAll)
    }

    func testStub() {
        let stub = Stub.StubSessionService()
        _ = stub.save(session: Session.stub)
        stub.logOut()

        sessionService.setupForTesting(isTesting: true, isLoggedIn: true, isLoggedOut: false)
        sessionService.setupForTesting(isTesting: true, isLoggedIn: false, isLoggedOut: true)
    }
}
