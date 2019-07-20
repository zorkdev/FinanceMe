@testable import MyFinance_iOS

class MockLaunchViewModel: LaunchViewModelType {
    var didCallViewDidAppear = false
    func viewDidAppear() {
        didCallViewDidAppear = true
    }

    var lastInjectValue: ViewModelDelegate?
    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }
}
