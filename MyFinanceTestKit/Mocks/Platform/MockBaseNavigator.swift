import PromiseKit
@testable import MyFinanceKit

class MockBaseNavigator: BaseNavigatorType {

    var window: WindowType?
    var viewControllers: [ViewControllerType] = []

    init() {}

    required init(window: WindowType) {}
    func dismiss() -> Promise<Void> { return Promise() }
    func popToRoot() -> Promise<Void> { return Promise() }

}
