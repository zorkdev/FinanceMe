@testable import MyFinance_iOS

class MockAuthViewModelDelegate: AuthViewModelDelegate {
    // swiftlint:disable discouraged_optional_boolean
    var lastUpdateTryAgainValue: Bool?
    var lastUpdateLogoValue: Bool?

    func updateTryAgain(isHidden: Bool) {
        lastUpdateTryAgainValue = isHidden
    }

    func updateLogo(isHidden: Bool) {
        lastUpdateLogoValue = isHidden
    }
}
