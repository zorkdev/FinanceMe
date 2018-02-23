@testable import MyFinanceKit

class ViewModelTypeTests: XCTestCase {

    struct ViewModel: ViewModelType {
        //swiftlint:disable:next nesting
        typealias ServiceProvider = NetworkServiceProvider
        let serviceProvider: ServiceProvider = MockAppState()
    }

    func testViewDidLoad() {
        ViewModel().viewDidLoad()
    }

}
