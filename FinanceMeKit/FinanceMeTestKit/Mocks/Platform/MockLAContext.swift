import LocalAuthentication
@testable import FinanceMeKit

public class MockLAContext: LAContextType {
    public required init() {
        MockLAContext.didCallInvalidate = false
    }

    deinit {
        MockLAContext.delay = 0
    }

    public static var canEvaluatePolicyReturnValue = true
    public func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        if MockLAContext.canEvaluatePolicyReturnValue == false {
            error?.pointee = TestError() as NSError
        }
        return MockLAContext.canEvaluatePolicyReturnValue
    }

    public static var delay: TimeInterval = 0
    public static var lastLocalizedReason: String?
    public static var evaluatePolicyReturnValue = true
    public func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        MockLAContext.lastLocalizedReason = localizedReason
        DispatchQueue.main.asyncAfter(deadline: .now() + MockLAContext.delay) {
            let error = MockLAContext.evaluatePolicyReturnValue ? nil : TestError()
            reply(MockLAContext.evaluatePolicyReturnValue, error)
        }
    }

    public static var didCallInvalidate = false
    public func invalidate() {
        MockLAContext.didCallInvalidate = true
    }
}
