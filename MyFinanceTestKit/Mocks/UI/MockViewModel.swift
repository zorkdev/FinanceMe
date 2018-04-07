import PromiseKit
@testable import MyFinanceKit

class MockViewModel: ViewModelType {

    //swiftlint:disable weak_delegate
    var lastDelegate: ViewModelDelegate?
    func inject(delegate: ViewModelDelegate) {
        lastDelegate = delegate
    }

}
