import PromiseKit
@testable import MyFinance_iOS

class MockNavigator: NavigatorType {
    weak var appState: AppStateiOSType!
    var window: WindowType?
    var viewControllers = [ViewControllerType]()

    required init(window: WindowType) {}

    var didCallCreateNavigationStack = false
    var lastViewModel: ViewModelType?
    func createNavigationStack(scene: Scene, viewModel: ViewModelType?) {
        didCallCreateNavigationStack = true
        lastViewModel = viewModel
    }

    var lastAuthViewModelType: AuthViewModelType?
    func createAuthStack(viewModel: AuthViewModelType) {
        lastAuthViewModelType = viewModel
    }

    var lastMoveToValue: (scene: Scene, viewModel: ViewModelType?)?
    func moveTo(scene: Scene, viewModel: ViewModelType?) {
        lastMoveToValue = (scene, viewModel)
    }

    @discardableResult
    func dismiss() -> Promise<Void> {
        return Promise()
    }

    @discardableResult
    func popToRoot() -> Promise<Void> {
        return Promise()
    }

    var didCallShowAuthWindow = false
    func showAuthWindow() {
        didCallShowAuthWindow = true
    }

    var didCallHideAuthWindow = false
    func hideAuthWindow() {
        didCallHideAuthWindow = true
    }
}
