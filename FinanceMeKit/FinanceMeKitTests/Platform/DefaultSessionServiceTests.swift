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

    func testSaveSession() throws {
        let expectedSession = Session.stub
        dataService.saveReturnValue = .success(())

        try sessionService.save(session: expectedSession).get()

        XCTAssertEqual(dataService.savedValues.first as? Session, expectedSession)
    }

    #if os(iOS) || os(macOS)
    func testLogOut() {
        sessionService.logOut()

        XCTAssertTrue(dataService.didCallRemoveAll)
    }
    #endif

    func testStub() {
        let stub = Stub.StubSessionService()
        _ = stub.save(session: Session.stub)
        #if os(iOS) || os(macOS)
        stub.logOut()
        #endif
    }
}
