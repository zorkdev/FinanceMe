@testable import MyFinance_iOS

class MockAuthViewModel: AuthViewModelType {

    var didCallAuthenticate = false
    var didCallAddOcclusion = false
    var didCallTryAgainButtonTapped = false
    var lastInjectValue: ViewModelDelegate?

    weak var delegate: AuthViewModelDelegate?

    func authenticate() {
        didCallAuthenticate = true
    }

    func addOcclusion() {
        didCallAddOcclusion = true
    }

    func tryAgainButtonTapped() {
        didCallTryAgainButtonTapped = true
    }

    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }

}
