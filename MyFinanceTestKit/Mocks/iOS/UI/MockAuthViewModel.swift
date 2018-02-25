@testable import MyFinance_iOS

class MockAuthViewModel: AuthViewModelType {

    var didCallAuthenticate = false
    var didCallAddOcclusion = false
    var didCallTryAgainButtonTapped = false

    //swiftlint:disable:next weak_delegate
    var delegate: AuthViewModelDelegate?

    func authenticate() {
        didCallAuthenticate = true
    }

    func addOcclusion() {
        didCallAddOcclusion = true
    }

    func tryAgainButtonTapped() {
        didCallTryAgainButtonTapped = true
    }

}
