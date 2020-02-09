import Combine
import AppKit

public protocol MenuItem: AnyObject {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
    var isEnabled: Bool { get set }
}

extension NSMenuItem: MenuItem {}

final class MenuController {
    private let appState: AppState
    private let viewModel: RootViewModel
    private let preferencesMenuItem: MenuItem
    private let newTransactionMenuItem: MenuItem
    private var cancellables: Set<AnyCancellable> = []
    private weak var preferencesVindow: NSWindow?

    init(appState: AppState,
         preferencesMenuItem: MenuItem,
         newTransactionMenuItem: MenuItem) {
        self.appState = appState
        self.viewModel = RootViewModel(service: appState.sessionService, businessLogic: appState.sessionBusinessLogic)
        self.preferencesMenuItem = preferencesMenuItem
        self.newTransactionMenuItem = newTransactionMenuItem
        setupBindings()
    }

    @objc
    func onTapPreferences(_ sender: Any) {
        guard preferencesVindow == nil else {
            preferencesVindow?.makeKeyAndOrderFront(nil)
            return
        }

        preferencesVindow = SettingsView(appState: appState).window
    }

    @objc
    func onTapNewTransaction(_ sender: Any) {
        _ = TransactionDetailView(transaction: nil, appState: appState)
    }
}

private extension MenuController {
    func setupBindings() {
        preferencesMenuItem.target = self
        preferencesMenuItem.action = #selector(onTapPreferences)

        newTransactionMenuItem.target = self
        newTransactionMenuItem.action = #selector(onTapNewTransaction)

        viewModel.$isLoggedIn
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink {
                self.preferencesMenuItem.isEnabled = $0
                self.newTransactionMenuItem.isEnabled = $0
            }.store(in: &cancellables)
    }
}
