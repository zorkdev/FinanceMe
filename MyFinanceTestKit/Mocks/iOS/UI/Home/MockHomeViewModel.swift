@testable import MyFinance_iOS

class MockHomeViewModel: HomeViewModelType {

    weak var lastInjectValue: ViewModelDelegate?

    func numberOfSections(in tab: HomeViewModel.Tab) -> Int {
        return 0
    }

    func numberOfRows(in tab: HomeViewModel.Tab, in section: Int) -> Int {
        return 0
    }

    func cellModel(for tab: HomeViewModel.Tab, section: Int, row: Int) -> HomeCellModelType? {
        return nil
    }

    func header(for tab: HomeViewModel.Tab, section: Int) -> String? {
        return nil
    }

    func canEdit(tab: HomeViewModel.Tab, section: Int, row: Int) -> Bool {
        return false
    }

    func didSelect(tab: HomeViewModel.Tab, section: Int, row: Int) {}

    func delete(from tab: HomeViewModel.Tab, section: Int, row: Int) {}

    func height(for tab: HomeViewModel.Tab, section: Int, row: Int) -> CGFloat {
        return 0
    }

    func refreshTapped() {}
    func settingsButtonTapped() {}
    func addTransactionButtonTapped() {}

    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }

    func didCreate(transaction: Transaction) {}
    func didUpdate(transaction: Transaction) {}
    func didUpdate(user: User) {}

}
