@testable import MyFinanceKit

class ViewModelTypeTests: XCTestCase {

    struct ViewModel: ViewModelType {}

    func testViewDidLoad() {
        ViewModel().viewDidLoad()
    }

}
