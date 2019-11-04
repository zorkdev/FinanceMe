import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class SessionBusinessLogicTests: XCTestCase {
    var networkService: MockNetworkService!
    var sessionService: MockSessionService!
    var businessLogic: SessionBusinessLogic!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        sessionService = MockSessionService()
        businessLogic = SessionBusinessLogic(networkService: networkService, sessionService: sessionService)
    }

    func testLoginLogOut_Success() {
        let expectedBody = Credentials.stub
        let expectedValue = Session.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        sessionService.saveReturnValue = .success(())
        sessionService.hasSession = true

        businessLogic.login(credentials: expectedBody).assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .login)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .post)
            XCTAssertEqual(self.networkService.lastPerformParams?.body as? Credentials, expectedBody)
            XCTAssertEqual(self.sessionService.lastSaveParam, expectedValue)
        }

        businessLogic.isLoggedIn.assertSuccess(self) { XCTAssertTrue($0) }

        sessionService.hasSession = false
        businessLogic.logOut()

        businessLogic.isLoggedIn.assertSuccess(self) { XCTAssertFalse($0) }
        XCTAssertTrue(sessionService.didCallLogOut)
    }

    func testLogin_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.login(credentials: Credentials.stub).assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.isLoggedIn.assertSuccess(self) { XCTAssertFalse($0) }
    }

    func testStub() {
        let stub = Stub.StubSessionBusinessLogic()
        _ = stub.login(credentials: Credentials.stub)
        stub.logOut()
    }
}
