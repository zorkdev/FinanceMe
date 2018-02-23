@testable import MyFinanceKit

class TodayPresentableTests: XCTestCase {

    var mockTodayPresentable: MockTodayPresentable?
    var mockTodayDisplayModel: MockTodayDisplayModel?
    var mockAppState: MockAppState?
    var mockNetworkService: MockNetworkService?
    var mockDataService: MockDataService?

    //swiftlint:disable:next weak_delegate
    var mockTodayViewModelDelegate: MockTodayViewModelDelegate?

    override func setUp() {
        super.setUp()

        mockDataService = MockDataService()
        mockNetworkService = MockNetworkService()
        mockAppState = MockAppState(dataService: mockDataService!,
                                    networkService: mockNetworkService!)
        mockTodayDisplayModel = MockTodayDisplayModel()
        mockTodayViewModelDelegate = MockTodayViewModelDelegate()
        mockTodayPresentable = MockTodayPresentable(serviceProvider: mockAppState!,
                                                    displayModel: mockTodayDisplayModel!,
                                                    delegate: mockTodayViewModelDelegate!)
    }

    func testViewDidLoad() {
        let expectedUser = User(name: "User Name",
                                payday: 10,
                                startDate: Date(),
                                largeTransaction: 10,
                                allowance: 100.22)

        let expectedBalance = Balance(clearedBalance: 100,
                                      effectiveBalance: 20,
                                      pendingTransactions: 90.22,
                                      availableToSpend: 100,
                                      acceptedOverdraft: 100,
                                      currency: "GBP",
                                      amount: 100)

        mockDataService?.loadReturnValues = [expectedUser, expectedBalance]
        mockNetworkService?.returnJSONDecodableValues = [expectedUser, expectedBalance]
        mockTodayPresentable!.viewDidLoad()

        XCTAssertEqual(mockTodayViewModelDelegate?.lastBalance?.string, "£20.00")
        XCTAssertEqual(mockTodayViewModelDelegate?.lastAllowance?.string, "£100.22")
        XCTAssertEqual(mockTodayViewModelDelegate?.lastAllowanceIcon, "😇")
    }

    func testSetupDefaults() {
        let expectedUser = User(name: "User Name",
                                payday: 10,
                                startDate: Date(),
                                largeTransaction: 10,
                                allowance: 100.22)

        let expectedBalance = Balance(clearedBalance: 100,
                                      effectiveBalance: 20,
                                      pendingTransactions: 90.22,
                                      availableToSpend: 100,
                                      acceptedOverdraft: 100,
                                      currency: "GBP",
                                      amount: 100)

        mockDataService?.loadReturnValues = [expectedUser, expectedBalance]
        mockTodayPresentable!.setupDefaults()

        XCTAssertEqual(mockTodayViewModelDelegate?.lastBalance?.string, "£20.00")
        XCTAssertEqual(mockTodayViewModelDelegate?.lastAllowance?.string, "£100.22")
        XCTAssertEqual(mockTodayViewModelDelegate?.lastAllowanceIcon, "😇")
    }

    func testUpdateData() {
        let expectedUser = User(name: "User Name",
                                payday: 10,
                                startDate: Date(),
                                largeTransaction: 10,
                                allowance: 100.22)

        let expectedBalance = Balance(clearedBalance: 100,
                                      effectiveBalance: 20,
                                      pendingTransactions: 90.22,
                                      availableToSpend: 100,
                                      acceptedOverdraft: 100,
                                      currency: "GBP",
                                      amount: 100)

        mockDataService?.loadReturnValues = [expectedUser, expectedBalance]
        mockNetworkService?.returnJSONDecodableValues = [expectedUser, expectedBalance]

        _ = mockTodayPresentable!.updateData().done {
            XCTAssertEqual(self.mockTodayViewModelDelegate?.lastBalance?.string, "£20.00")
            XCTAssertEqual(self.mockTodayViewModelDelegate?.lastAllowance?.string, "£100.22")
            XCTAssertEqual(self.mockTodayViewModelDelegate?.lastAllowanceIcon, "😇")
            XCTAssertTrue(self.mockDataService!.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)
            XCTAssertTrue(self.mockDataService!.savedValues
                .contains(where: { ($0 as? Balance) == expectedBalance }) == true)
        }
    }

    func testGetUser() {
        let expectedUser = User(name: "User Name",
                                payday: 10,
                                startDate: Date(),
                                largeTransaction: 10,
                                allowance: 100.22)

        mockDataService?.loadReturnValues = [expectedUser]
        mockNetworkService?.returnJSONDecodableValues = [expectedUser]

        _ = mockTodayPresentable!.getUser().done {
            XCTAssertEqual(self.mockTodayViewModelDelegate?.lastAllowance?.string, "£100.22")
            XCTAssertEqual(self.mockTodayViewModelDelegate?.lastAllowanceIcon, "😇")
            XCTAssertTrue(self.mockDataService!.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)
        }
    }

    func testGetBalance() {
        let expectedBalance = Balance(clearedBalance: 100,
                                      effectiveBalance: 20,
                                      pendingTransactions: 90.22,
                                      availableToSpend: 100,
                                      acceptedOverdraft: 100,
                                      currency: "GBP",
                                      amount: 100)

        mockDataService?.loadReturnValues = [expectedBalance]
        mockNetworkService?.returnJSONDecodableValues = [expectedBalance]

        _ = mockTodayPresentable!.getBalance().done {
        XCTAssertEqual(self.mockTodayViewModelDelegate?.lastBalance?.string, "£20.00")
        XCTAssertTrue(self.mockDataService!.savedValues
            .contains(where: { ($0 as? Balance) == expectedBalance }) == true)
        }
    }

    func testCreateAttributedString() {
        XCTAssertEqual(mockTodayPresentable?.createAttributedString(from: 10).string, "£10.00")
        XCTAssertEqual(mockTodayPresentable?.createAttributedString(from: -10).string, "-£10.00")
    }

}
