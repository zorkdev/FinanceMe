@testable import MyFinance_iOS

class MockLaunchViewModel: LaunchViewModelType {

    func viewDidAppear() {}

    var lastInjectValue: ViewModelDelegate?
    func inject(delegate: ViewModelDelegate) {
        lastInjectValue = delegate
    }

}
