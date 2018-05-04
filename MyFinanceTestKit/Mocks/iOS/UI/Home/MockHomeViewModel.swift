@testable import MyFinance_iOS

class MockHomeViewModel: HomeViewModelType {

    weak var lastInjectValue: ViewModelDelegate?

    func settingsButtonTapped() {}
    func addTransactionButtonTapped() {}

    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }

    func didCreate(transaction: Transaction) {}
    func didUpdate(transaction: Transaction) {}
    func didUpdate(user: User) {}

}
