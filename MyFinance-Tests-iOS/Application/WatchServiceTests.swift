import WatchConnectivity
@testable import MyFinance_iOS

class WatchServiceTests: XCTestCase {

    var mockWCSession: MockWCSession!
    var mockDataService: MockDataService!

    override func setUp() {
        super.setUp()

        mockWCSession = MockWCSession()
        mockDataService = MockDataService()
    }

    func testInit_Success() {
        MockWCSession.isSupportedValue = true

        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)

        XCTAssertTrue(mockWCSession.didCallActivate)
        XCTAssertEqual(mockWCSession.delegate as? WatchService, watchService)
    }

    func testInit_Failure() {
        MockWCSession.isSupportedValue = false

        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)

        XCTAssertFalse(mockWCSession.didCallActivate)
        XCTAssertEqual(mockWCSession.delegate as? WatchService, watchService)
    }

    func testUpdateComplication_Success() {
        MockWCSession.isSupportedValue = true
        mockWCSession.newActivationState = .activated
        mockWCSession.isComplicationEnabled = true

        let user = Factory.makeUser()
        let previousAllowance = Allowance(allowance: 10)
        mockDataService.loadReturnValues = [user, previousAllowance]
        let expectedAllowance = Allowance(allowance: user.allowance)
        let expectedUserInfo = [Allowance.instanceName: expectedAllowance.allowance]

        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)

        watchService.updateComplication()

        XCTAssertTrue(mockDataService.savedValues
            .contains(where: { ($0 as? Allowance) == expectedAllowance }) == true)
        XCTAssertEqual(mockWCSession.lastTransfer as? [String: Double], expectedUserInfo)
    }

    func testUpdateComplication_FailureSameAllowance() {
        MockWCSession.isSupportedValue = true
        mockWCSession.newActivationState = .activated
        mockWCSession.isComplicationEnabled = true

        let user = Factory.makeUser()
        let previousAllowance = Allowance(allowance: user.allowance)
        mockDataService.loadReturnValues = [user, previousAllowance]

        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)

        watchService.updateComplication()

        XCTAssertTrue(mockDataService.savedValues.isEmpty)
        XCTAssertNil(mockWCSession.lastTransfer)
    }

    func testUpdateComplication_FailureInactive() {
        MockWCSession.isSupportedValue = true
        mockWCSession.newActivationState = .inactive
        mockWCSession.isComplicationEnabled = true

        let user = Factory.makeUser()
        let previousAllowance = Allowance(allowance: 10)
        mockDataService.loadReturnValues = [user, previousAllowance]

        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)

        watchService.updateComplication()

        XCTAssertTrue(mockDataService.savedValues.isEmpty)
        XCTAssertNil(mockWCSession.lastTransfer)
    }

    func testUpdateComplication_FailureComplicationDisabled() {
        MockWCSession.isSupportedValue = true
        mockWCSession.newActivationState = .activated
        mockWCSession.isComplicationEnabled = false

        let user = Factory.makeUser()
        let previousAllowance = Allowance(allowance: 10)
        mockDataService.loadReturnValues = [user, previousAllowance]

        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)

        watchService.updateComplication()

        XCTAssertTrue(mockDataService.savedValues.isEmpty)
        XCTAssertNil(mockWCSession.lastTransfer)
    }

    func testDelegateMethods() {
        let watchService = WatchService(wcSession: mockWCSession,
                                        dataService: mockDataService)
        watchService.session(WCSession.default,
                             activationDidCompleteWith: .activated,
                             error: nil)
        watchService.sessionDidBecomeInactive(WCSession.default)
        watchService.sessionDidDeactivate(WCSession.default)
    }

}
