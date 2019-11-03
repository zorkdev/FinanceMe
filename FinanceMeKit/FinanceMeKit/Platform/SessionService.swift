protocol SessionService {
    var hasSession: Bool { get }
    var session: Session? { get }

    func save(session: Session) -> Result<Void, Error>
    #if os(iOS) || os(macOS)
    func logOut()
    #endif
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

    #if os(iOS) || os(macOS)
    func logOut() {
        dataService.removeAll()
    }
    #endif
}

#if DEBUG
extension Stub {
    class StubSessionService: SessionService {
        let hasSession = true
        let session: Session? = nil
        func save(session: Session) -> Result<Void, Error> { .success(()) }
        #if os(iOS) || os(macOS)
        func logOut() {}
        #endif
    }
}
#endif
