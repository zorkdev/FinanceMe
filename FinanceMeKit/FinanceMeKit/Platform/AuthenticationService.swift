import Combine
import LocalAuthentication

public protocol LAContextType {
    init()
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
    func invalidate()
}

extension LAContext: LAContextType {}

public protocol AuthenticationService {
    func authenticate() -> AnyPublisher<Void, Error>
    func invalidate()
}

public class LAContextAuthenticationService: AuthenticationService {
    public enum AuthenticationError: Error {
        case missingSession
    }

    private let sessionService: SessionService
    private let laContextType: LAContextType.Type
    private let reason: String
    private var context: LAContextType?

    public init(sessionService: SessionService,
                laContextType: LAContextType.Type,
                reason: String) {
        self.sessionService = sessionService
        self.laContextType = laContextType
        self.reason = reason
    }

    public func authenticate() -> AnyPublisher<Void, Error> {
        var error: NSError?
        let context = laContextType.init()
        self.context = context

        guard sessionService.hasSession, context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            defer { self.context = nil }
            return Fail(error: error as Error? ?? AuthenticationError.missingSession).eraseToAnyPublisher()
        }

        return Future { promise in
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: self.reason) { success, error in
                defer { self.context = nil }
                guard success else {
                    promise(.failure(error!))
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }

    public func invalidate() {
        context?.invalidate()
    }
}
