import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class UserBusinessLogicTests: AsyncTestCase {
    var networkService: MockNetworkService!
    var dataService: MockDataService!
    var businessLogic: UserBusinessLogic!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        dataService = MockDataService()
        businessLogic = UserBusinessLogic(networkService: networkService, dataService: dataService)
    }

    func testFetchUser() {
        let expectedValue = User.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.fetchUser()

        waitForEvent {}

        businessLogic.user.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
    }

    func testGetUser_Success() {
        let expectedValue = User.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.getUser().assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .user)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .get)
            XCTAssertNil(self.networkService.lastPerformParams?.body)
            XCTAssertEqual(self.dataService.savedValues.first as? User, expectedValue)
        }

        businessLogic.user.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
    }

    func testGetUser_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.getUser().assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.user.assertSuccess(self) { XCTAssertNil($0) }
    }

    #if os(iOS) || os(macOS)
    func testUpdate_Success() {
        let expectedValue = User.stub
        networkService.performReturnValues = [expectedValue.jsonEncoded()]
        dataService.saveReturnValue = .success(())

        businessLogic.update(user: expectedValue).assertSuccess(self) {
            XCTAssertEqual(self.networkService.lastPerformParams?.api as? API, .user)
            XCTAssertEqual(self.networkService.lastPerformParams?.method, .patch)
            XCTAssertEqual(self.networkService.lastPerformParams?.body as? User, expectedValue)
            XCTAssertEqual(self.dataService.savedValues.first as? User, expectedValue)
        }

        businessLogic.user.assertSuccess(self) { XCTAssertEqual($0, expectedValue) }
    }

    func testUpdate_Failure() {
        networkService.performReturnValues = [.failure(TestError())]

        businessLogic.update(user: User.stub).assertFailure(self) { XCTAssertTrue($0 is TestError) }
        businessLogic.user.assertSuccess(self) { XCTAssertNil($0) }
    }
    #endif

    func testStub() {
        let stub = Stub.StubUserBusinessLogic()
        stub.fetchUser()
        #if os(iOS) || os(macOS)
        _ = stub.getUser()
        _ = stub.update(user: User.stub)
        #endif
    }
}
