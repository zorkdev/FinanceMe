import MyFinanceKit

class MockViewModel: ViewModelType {
    //swiftlint:disable:next weak_delegate
    var lastDelegate: ViewModelDelegate?
    func inject(delegate: ViewModelDelegate) {
        lastDelegate = delegate
    }
}
