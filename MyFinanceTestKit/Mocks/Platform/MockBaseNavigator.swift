import PromiseKit
@testable import MyFinanceKit

class MockBaseNavigator: BaseNavigatorType {

    var appState: AppStateType!
    var window: WindowType?
    var viewControllers: [ViewControllerType] = []

    init() {}

    required init(window: WindowType) {}
    func dismiss() -> Promise<Void> { return .value(Void()) }
    func popToRoot() {}

}
