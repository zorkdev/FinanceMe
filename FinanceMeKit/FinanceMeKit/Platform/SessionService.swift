public protocol SessionServiceProvider {
    var sessionService: SessionService { get }
}

public protocol SessionService {
    var hasSession: Bool { get }
    var session: Session? { get }

    func save(session: Session)
    func logOut()
}

public class DefaultSessionService: SessionService {
    private let dataService: DataService

    public var hasSession: Bool { session != nil }
    public var session: Session? { Session.load(dataService: dataService) }

    public init(dataService: DataService) {
        self.dataService = dataService
    }

    public func save(session: Session) {
        session.save(dataService: dataService)
    }

    public func logOut() {
        dataService.removeAll()
    }
}
