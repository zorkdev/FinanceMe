import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class UserBusinessLogicTests: ServiceClientTestCase {
    var businessLogic: UserBusinessLogic!

    override func setUp() {
        super.setUp()
        businessLogic = UserBusinessLogic(serviceProvider: appState)
    }

    func testLogin_Success() {
        let expectedBody = Credentials.stub
        let expectedValue = Session.stub
        appState.mockNetworkService.performReturnValues = [expectedValue.jsonEncoded()]

        businessLogic.login(credentials: expectedBody).assertSuccess(self) {
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.api as? ZorkdevAPI, .login)
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.method, .post)
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.body as? Credentials, expectedBody)
            XCTAssertEqual(self.appState.mockSessionService.lastSaveParam, expectedValue)
        }
    }

    func testLogin_Failure() {
        appState.mockNetworkService.performReturnValues = [.failure(TestError())]

        businessLogic.login(credentials: Credentials.stub).assertFailure(self) { error in
            XCTAssertTrue(error is TestError)
        }
    }

    func testGetUser_Success() {
        let expectedValue = User.stub
        appState.mockNetworkService.performReturnValues = [expectedValue.jsonEncoded()]

        businessLogic.getUser().assertSuccess(self) { value in
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.api as? ZorkdevAPI, .user)
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.method, .get)
            XCTAssertNil(self.appState.mockNetworkService.lastPerformParams?.body)
            XCTAssertEqual(self.appState.mockDataService.savedValues.first as? User, expectedValue)
            XCTAssertEqual(value, expectedValue)
        }
    }

    func testGetUser_Failure() {
        appState.mockNetworkService.performReturnValues = [.failure(TestError())]

        businessLogic.getUser().assertFailure(self) { error in
            XCTAssertTrue(error is TestError)
        }
    }

    func testUpdate_Success() {
        let expectedValue = User.stub
        appState.mockNetworkService.performReturnValues = [expectedValue.jsonEncoded()]

        businessLogic.update(user: expectedValue).assertSuccess(self) { value in
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.api as? ZorkdevAPI, .user)
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.method, .patch)
            XCTAssertEqual(self.appState.mockNetworkService.lastPerformParams?.body as? User, expectedValue)
            XCTAssertEqual(self.appState.mockDataService.savedValues.first as? User, expectedValue)
            XCTAssertEqual(value, expectedValue)
        }
    }

    func testUpdate_Failure() {
        appState.mockNetworkService.performReturnValues = [.failure(TestError())]

        businessLogic.update(user: User.stub).assertFailure(self) { error in
            XCTAssertTrue(error is TestError)
        }
    }
}
