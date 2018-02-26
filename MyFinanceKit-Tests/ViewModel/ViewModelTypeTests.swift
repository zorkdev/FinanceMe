@testable import MyFinanceKit

class ViewModelTypeTests: XCTestCase {

    class ViewModel: ViewModelType {

        //swiftlint:disable:next nesting
        typealias ServiceProvider = NetworkServiceProvider
        let serviceProvider: ServiceProvider = MockAppState()

        func inject(delegate: ViewModelDelegate) {}
    }

    func testViewDidLoad() {
        ViewModel().viewDidLoad()
    }

}
