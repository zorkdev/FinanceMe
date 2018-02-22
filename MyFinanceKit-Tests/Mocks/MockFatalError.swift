@testable import MyFinanceKit

class MockFatalError: FatalErrorable {

    var didCallFatalError = false

    func fatalError(message: String) {
        didCallFatalError = true
    }

}
