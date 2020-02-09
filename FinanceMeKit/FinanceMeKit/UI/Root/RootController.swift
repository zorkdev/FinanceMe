import Combine
import AppKit

public protocol Application {
    var windows: [NSWindow] { get }
}

extension NSApplication: Application {}

public final class RootController {
    private let application: Application
    private let appState: AppState
    private let menuController: MenuController
    private let viewModel: RootViewModel
    private var cancellables: Set<AnyCancellable> = []

    public init(application: Application,
                appState: AppState,
                preferencesMenuItem: MenuItem,
                newTransactionMenuItem: MenuItem) {
        self.application = application
        self.appState = appState
        self.viewModel = RootViewModel(service: appState.sessionService, businessLogic: appState.sessionBusinessLogic)
        self.menuController = MenuController(appState: appState,
                                             preferencesMenuItem: preferencesMenuItem,
                                             newTransactionMenuItem: newTransactionMenuItem)
        setupBindings()
    }
}

private extension RootController {
    func setupBindings() {
        viewModel.$isLoggedIn
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink {
                self.application.windows.forEach { $0.orderOut(nil) }
                if $0 {
                    _ = HomeView(appState: self.appState)
                } else {
                    _ = LoginView(appState: self.appState)
                }
            }.store(in: &cancellables)
    }
}
