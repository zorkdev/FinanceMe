@testable import MyFinanceKit

class BaseNavigatorTypeTests: XCTestCase {
    func testInject_Success() {
        let mockBaseNavigator = MockBaseNavigator()
        let mockInjectableViewController = MockInjectableViewController()
        let mockViewModel = MockViewModel()

        mockBaseNavigator.inject(viewController: mockInjectableViewController,
                                 viewModel: mockViewModel)

        XCTAssertTrue(mockInjectableViewController.lastViewModel is MockViewModel)
        XCTAssertTrue(mockViewModel.lastDelegate is MockInjectableViewController)
    }

    func testInject_Failure() {
        let mockBaseNavigator = MockBaseNavigator()
        let mockViewController = MockViewController()
        let mockViewModel = MockViewModel()

        mockBaseNavigator.inject(viewController: mockViewController,
                                 viewModel: mockViewModel)

        XCTAssertTrue(mockViewModel.lastDelegate is MockViewController)
    }
}
