import Combine
import AppKit

class HomeToolbar: NSToolbar, ObservableObject {
    private let appState: AppState
    private let selectionState: SelectionState
    private let loadingState: LoadingState
    private let viewModel: HomeViewModel
    private var cancellables: Set<AnyCancellable> = []

    private let loadingView: NSProgressIndicator = {
        let view = NSProgressIndicator()
        view.style = .spinning
        view.controlSize = .small
        view.startAnimation(nil)
        return view
    }()

    private lazy var segmentedControlItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("segmentedControlItem"))
        let segmentedControl = NSSegmentedControl(labels: ["Feed", "Regulars", "Balances"],
                                                  trackingMode: .selectOne,
                                                  target: self,
                                                  action: #selector(onSelectedSegment))
        segmentedControl.selectedSegment = selectionState.selectedSegment
        item.view = segmentedControl
        return item
    }()

    private lazy var refreshItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("refreshItem"))
        let button = NSButton(image: NSImage(named: NSImage.refreshTemplateName)!,
                              target: self,
                              action: #selector(onTapRefresh))
        button.bezelStyle = .texturedRounded
        item.view = button
        item.toolTip = "Refresh"
        return item
    }()

    private lazy var loadingItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("loadingItem"))
        item.view = loadingView
        return item
    }()

    private lazy var newTransactionItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("newTransactionItem"))
        let button = NSButton(image: NSImage(named: NSImage.addTemplateName)!,
                              target: self,
                              action: #selector(onTapNewTransaction))
        button.bezelStyle = .texturedRounded
        item.view = button
        item.toolTip = "New Transaction"
        return item
    }()

    init(appState: AppState,
         loadingState: LoadingState,
         errorViewModel: ErrorViewModel,
         selectionState: SelectionState) {
        self.appState = appState
        self.loadingState = loadingState
        self.selectionState = selectionState
        self.viewModel = HomeViewModel(loadingState: loadingState,
                                       errorViewModel: errorViewModel,
                                       userBusinessLogic: appState.userBusinessLogic,
                                       transactionBusinessLogic: appState.transactionBusinessLogic,
                                       summaryBusinessLogic: appState.summaryBusinessLogic)
        super.init(identifier: "homeToolbar")
        delegate = self
        setupBindings()
    }
}

private extension HomeToolbar {
    func setupBindings() {
        loadingState.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { self.loadingView.isHidden = !$0 }
            .store(in: &cancellables)
    }
}

extension HomeToolbar {
    @objc
    func onTapRefresh(_ sender: Any) {
        self.viewModel.onRefresh()
    }

    @objc
    func onSelectedSegment(_ sender: NSSegmentedControl) {
        selectionState.selectedSegment = sender.selectedSegment
    }

    @objc
    func onTapNewTransaction(_ sender: Any) {
        _ = TransactionDetailView(transaction: nil, appState: appState)
    }
}

extension HomeToolbar: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [refreshItem.itemIdentifier,
         loadingItem.itemIdentifier,
         segmentedControlItem.itemIdentifier,
         newTransactionItem.itemIdentifier,
         NSToolbarItem.Identifier.flexibleSpace]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [refreshItem.itemIdentifier,
         loadingItem.itemIdentifier,
         NSToolbarItem.Identifier.flexibleSpace,
         segmentedControlItem.itemIdentifier,
         NSToolbarItem.Identifier.flexibleSpace,
         newTransactionItem.itemIdentifier]
    }

    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        [segmentedControlItem,
         loadingItem,
         refreshItem,
         newTransactionItem].first { $0.itemIdentifier == itemIdentifier }
    }
}
