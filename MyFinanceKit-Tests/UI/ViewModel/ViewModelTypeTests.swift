@testable import MyFinanceKit

class ViewModelTypeTests: XCTestCase {

    class ViewModel: ViewModelType {

        func inject(delegate: ViewModelDelegate) {}

    }

    func testViewDidLoad() {
        ViewModel().viewDidLoad()
    }

}
