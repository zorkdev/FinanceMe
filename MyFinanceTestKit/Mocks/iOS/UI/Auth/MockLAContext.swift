import LocalAuthentication
@testable import MyFinance_iOS

class MockLAContext: LAContextType {

    var canEvaluatePolicyReturnValue = true
    var evaluatePolicyReturnValue = true

    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        return canEvaluatePolicyReturnValue
    }

    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(evaluatePolicyReturnValue, nil)
    }

}
