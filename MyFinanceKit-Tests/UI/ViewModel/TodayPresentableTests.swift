@testable import MyFinanceKit

class TodayPresentableTests: ServiceClientTestCase {

    var mockTodayPresentable: MockTodayPresentable!
    var mockTodayDisplayModel: MockTodayDisplayModel!

    //swiftlint:disable:next weak_delegate
    var mockTodayViewModelDelegate: MockTodayViewModelDelegate!

    override func setUp() {
        super.setUp()

        mockTodayDisplayModel = MockTodayDisplayModel()
        mockTodayViewModelDelegate = MockTodayViewModelDelegate()
        mockTodayPresentable = MockTodayPresentable(serviceProvider: mockAppState,
                                                    displayModel: mockTodayDisplayModel,
                                                    delegate: mockTodayViewModelDelegate)
    }

    func testViewDidLoad() {
        let expectedUser = Factory.makeUser()
        let expectedBalance = Factory.makeBalance()

        mockAppState.mockDataService.loadReturnValues = [expectedUser, expectedBalance]
        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedUser, expectedBalance]
        mockTodayPresentable!.viewDidLoad()

        XCTAssertEqual(mockTodayViewModelDelegate.lastBalance?.string, "£20.00")
        XCTAssertEqual(mockTodayViewModelDelegate.lastAllowance?.string, "£100.22")
        XCTAssertEqual(mockTodayViewModelDelegate.lastAllowanceIcon, "😇")
    }

    func testSetupDefaults() {
        let expectedUser = Factory.makeUser()
        let expectedBalance = Factory.makeBalance()

        mockAppState.mockDataService.loadReturnValues = [expectedUser, expectedBalance]
        mockTodayPresentable!.setupDefaults()

        XCTAssertEqual(mockTodayViewModelDelegate.lastBalance?.string, "£20.00")
        XCTAssertEqual(mockTodayViewModelDelegate.lastAllowance?.string, "£100.22")
        XCTAssertEqual(mockTodayViewModelDelegate.lastAllowanceIcon, "😇")
    }

    func testUpdateData() {
        let expectedUser = Factory.makeUser()
        let expectedBalance = Factory.makeBalance()

        mockAppState.mockDataService.loadReturnValues = [expectedUser, expectedBalance]
        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedUser, expectedBalance]

        _ = mockTodayPresentable!.updateData().done {
            XCTAssertEqual(self.mockTodayViewModelDelegate.lastBalance?.string, "£20.00")
            XCTAssertEqual(self.mockTodayViewModelDelegate.lastAllowance?.string, "£100.22")
            XCTAssertEqual(self.mockTodayViewModelDelegate.lastAllowanceIcon, "😇")
            XCTAssertTrue(self.mockAppState.mockDataService.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)
            XCTAssertTrue(self.mockAppState.mockDataService.savedValues
                .contains(where: { ($0 as? Balance) == expectedBalance }) == true)
        }
    }

    func testGetUser() {
        let expectedUser = Factory.makeUser()

        mockAppState.mockDataService.loadReturnValues = [expectedUser]
        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedUser]

        _ = mockTodayPresentable!.getUser().done {
            XCTAssertEqual(self.mockTodayViewModelDelegate.lastAllowance?.string, "£100.22")
            XCTAssertEqual(self.mockTodayViewModelDelegate.lastAllowanceIcon, "😇")
            XCTAssertTrue(self.mockAppState.mockDataService.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)
        }
    }

    func testGetBalance() {
        let expectedBalance = Factory.makeBalance()

        mockAppState.mockDataService.loadReturnValues = [expectedBalance]
        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedBalance]

        _ = mockTodayPresentable!.getBalance().done {
        XCTAssertEqual(self.mockTodayViewModelDelegate.lastBalance?.string, "£20.00")
        XCTAssertTrue(self.mockAppState.mockDataService.savedValues
            .contains(where: { ($0 as? Balance) == expectedBalance }) == true)
        }
    }

    func testCreateAttributedString() {
        XCTAssertEqual(mockTodayPresentable?.createAttributedString(from: 10).string, "£10.00")
        XCTAssertEqual(mockTodayPresentable?.createAttributedString(from: -10).string, "-£10.00")
    }

}
