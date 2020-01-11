import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class LAContextAuthenticationServiceTests: AsyncTestCase {
    var sessionService: MockSessionService!
    var authenticationService: LAContextAuthenticationService!

    override func setUp() {
        super.setUp()
        sessionService = MockSessionService()
        authenticationService = LAContextAuthenticationService(sessionService: sessionService,
                                                               laContextType: MockLAContext.self)
    }

    func testAuthenticate_Success() {
        sessionService.hasSession = true
        MockLAContext.canEvaluatePolicyReturnValue = true
        MockLAContext.evaluatePolicyReturnValue = true

        authenticationService.authenticate(reason: "Test").assertSuccess(self) {
            XCTAssertEqual(MockLAContext.lastLocalizedReason, "Test")
        }
    }

    func testAuthenticateNoSession_Failure() {
        sessionService.hasSession = false
        MockLAContext.canEvaluatePolicyReturnValue = true
        MockLAContext.evaluatePolicyReturnValue = true

        authenticationService.authenticate(reason: "Test").assertFailure(self) { _ in }
    }

    func testAuthenticateCannotEvaluate_Failure() {
        sessionService.hasSession = true
        MockLAContext.canEvaluatePolicyReturnValue = false
        MockLAContext.evaluatePolicyReturnValue = true

        authenticationService.authenticate(reason: "Test").assertFailure(self) { _ in }
    }

    func testAuthenticateEvaluation_Failure() {
        sessionService.hasSession = true
        MockLAContext.canEvaluatePolicyReturnValue = true
        MockLAContext.evaluatePolicyReturnValue = false

        authenticationService.authenticate(reason: "Test").assertFailure(self) { _ in }
    }

    func testStub() {
        let stub = Stub.StubAuthenticationService()
        _ = stub.authenticate(reason: "")
    }
}
