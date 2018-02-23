@testable import MyFinanceKit

class TodayPresentableTests: XCTestCase {

    var mockTodayPresentable: MockTodayPresentable?
    var mockTodayDisplayModel: MockTodayDisplayModel?
    var mockNetworkService: MockNetworkService?
    var mockDataService: MockDataService?

    //swiftlint:disable:next weak_delegate
    var mockTodayViewModelDelegate: MockTodayViewModelDelegate?

    override func setUp() {
        super.setUp()

        mockDataService = MockDataService()
        mockNetworkService = MockNetworkService()
        let mockAppState = MockNetworkDataServiceProvider(dataService: mockDataService!,
                                                          networkService: mockNetworkService!)
        mockTodayDisplayModel = MockTodayDisplayModel()
        mockTodayViewModelDelegate = MockTodayViewModelDelegate()
        mockTodayPresentable = MockTodayPresentable(networkDataServiceProvider: mockAppState,
                                                    displayModel: mockTodayDisplayModel!,
                                                    delegate: mockTodayViewModelDelegate!)
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

        mockNetworkService?.returnJSONDecodableValues = [expectedUser, expectedBalance]
        mockTodayPresentable!.viewDidLoad()
    }

}
