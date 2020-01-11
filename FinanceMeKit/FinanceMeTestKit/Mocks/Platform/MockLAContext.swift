import LocalAuthentication
@testable import FinanceMeKit

public final class MockLAContext: LAContextType {
    public required init() {}

    public static var canEvaluatePolicyReturnValue = true
    public func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        if MockLAContext.canEvaluatePolicyReturnValue == false {
            error?.pointee = TestError() as NSError
        }
        return MockLAContext.canEvaluatePolicyReturnValue
    }

    public static var lastLocalizedReason: String?
    public static var evaluatePolicyReturnValue = true
    public func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        MockLAContext.lastLocalizedReason = localizedReason
        let error = MockLAContext.evaluatePolicyReturnValue ? nil : TestError()
        reply(MockLAContext.evaluatePolicyReturnValue, error)
    }
}
