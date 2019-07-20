@testable import MyFinance_tvOS

class MainViewControllerTests: ServiceClientTestCase {
    var mockViewModel: MockTodayPresentable!
    var mainViewController: MainViewController!

    override func setUp() {
        super.setUp()

        mainViewController = MainViewController.instantiate()
        mockViewModel = MockTodayPresentable(serviceProvider: mockAppState,
                                             displayModel: MockTodayDisplayModel(),
                                             delegate: mainViewController)
        mainViewController.viewModel = mockViewModel
    }

    func testViewWillAppear() {
        mainViewController.viewWillAppear(true)
    }

    func testTodayViewModelDelegateMethods() {
        _ = mainViewController.view
        mainViewController.set(allowance: NSAttributedString(string: "allowance"))
        mainViewController.set(balance: NSAttributedString(string: "balance"))
        mainViewController.set(allowanceIcon: "icon")
    }
}
