protocol SessionService {
    var hasSession: Bool { get }
    var session: Session? { get }

    func save(session: Session) -> Result<Void, Error>
    func logOut()
}

class DefaultSessionService: SessionService {
    private let dataService: DataService

    var hasSession: Bool { session != nil }
    var session: Session? { Session.load(dataService: dataService) }

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func save(session: Session) -> Result<Void, Error> {
        session.save(dataService: dataService)
    }

    func logOut() {
        dataService.removeAll()
    }
}
