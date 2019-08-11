import Combine
import LocalAuthentication

public protocol AuthenticationServiceProvider {
    var authenticationService: AuthenticationService { get }
}

protocol LAContextType {
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

class LAContextAuthenticationService: AuthenticationService {
    enum AuthenticationError: Error {
        case missingSession
    }

    private let sessionService: SessionService
    private let laContextType: LAContextType.Type
    private let reason: String
    private var context: LAContextType?

    init(sessionService: SessionService,
         laContextType: LAContextType.Type,
         reason: String) {
        self.sessionService = sessionService
        self.laContextType = laContextType
        self.reason = reason
    }

    func authenticate() -> AnyPublisher<Void, Error> {
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

    func invalidate() {
        context?.invalidate()
    }
}
