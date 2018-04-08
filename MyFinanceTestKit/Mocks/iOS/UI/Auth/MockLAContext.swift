import LocalAuthentication
@testable import MyFinance_iOS

class MockLAContext: LAContextType {

    var canEvaluatePolicyReturnValue = true
    var evaluatePolicyReturnValue = true

    var createCanEvaluatePolicyReturnValue = true
    var createEvaluatePolicyReturnValue = true

    init() {}

    init(canEvaluatePolicyReturnValue: Bool, evaluatePolicyReturnValue: Bool) {
        self.canEvaluatePolicyReturnValue = canEvaluatePolicyReturnValue
        self.evaluatePolicyReturnValue = evaluatePolicyReturnValue
    }

    func createContext() -> LAContextType {
        return MockLAContext(canEvaluatePolicyReturnValue: createCanEvaluatePolicyReturnValue,
                             evaluatePolicyReturnValue: createEvaluatePolicyReturnValue)
    }

    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        return canEvaluatePolicyReturnValue
    }

    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(evaluatePolicyReturnValue, nil)
    }

}
