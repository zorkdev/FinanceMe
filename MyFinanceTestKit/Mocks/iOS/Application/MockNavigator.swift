import PromiseKit
@testable import MyFinance_iOS

class MockNavigator: NavigatorType {

    var didCallCreateNavigationStack = false
    var didCallShowAuthWindow = false
    var didCallHideAuthWindow = false
    var lastViewModel: ViewModelType?
    var lastAuthViewModelType: AuthViewModelType?

    weak var appState: AppStateiOSType!
    var window: WindowType?
    var viewControllers = [ViewControllerType]()

    required init(window: WindowType) {}

    func createNavigationStack(scene: Scene, viewModel: ViewModelType?) {
        didCallCreateNavigationStack = true
        lastViewModel = viewModel
    }

    func createAuthStack(viewModel: AuthViewModelType) {
        lastAuthViewModelType = viewModel
    }

    func moveTo(scene: Scene, viewModel: ViewModelType?) {}

    @discardableResult func dismiss() -> Promise<Void> {
        return Promise()
    }

    @discardableResult func popToRoot() -> Promise<Void> {
        return Promise()
    }

    func showAuthWindow() {
        didCallShowAuthWindow = true
    }

    func hideAuthWindow() {
        didCallHideAuthWindow = true
    }

}
