import Combine
import LocalAuthentication

protocol LAContextType {
    init()
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
}

extension LAContext: LAContextType {}

protocol AuthenticationService {
    func authenticate(reason: String) -> AnyPublisher<Void, Error>
}

class LAContextAuthenticationService: AuthenticationService {
    enum AuthenticationError: Error {
        case missingSession
    }

    private let sessionService: SessionService
    private let laContextType: LAContextType.Type
    private var context: LAContextType?

    init(sessionService: SessionService,
         laContextType: LAContextType.Type) {
        self.sessionService = sessionService
        self.laContextType = laContextType
    }

    func authenticate(reason: String) -> AnyPublisher<Void, Error> {
        var error: NSError?
        let context = laContextType.init()
        self.context = context

        guard sessionService.hasSession, context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            defer { self.context = nil }
            return Fail(error: error as Error? ?? AuthenticationError.missingSession).eraseToAnyPublisher()
        }

        return Future { promise in
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                defer { self.context = nil }
                guard success else {
                    promise(.failure(error!))
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}

#if DEBUG
extension Stub {
    class StubAuthenticationService: AuthenticationService {
        func authenticate(reason: String) -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
    }
}
#endif
