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
        dataService.saveReturnValue = .success(())

        guard case .success = sessionService.save(session: expectedSession) else {
            XCTFail("Should not have thrown error.")
            return
        }

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
    }
}
