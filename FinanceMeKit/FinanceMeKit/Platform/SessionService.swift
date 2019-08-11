public protocol SessionServiceProvider {
    var sessionService: SessionService { get }
}

public protocol SessionService {
    var hasSession: Bool { get }
    var session: Session? { get }

    func save(session: Session)
    func logOut()
}

class DefaultSessionService: SessionService {
    private let dataService: DataService

    var hasSession: Bool { session != nil }
    var session: Session? { Session.load(dataService: dataService) }

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func save(session: Session) {
        session.save(dataService: dataService)
    }

    func logOut() {
        dataService.removeAll()
    }
}
