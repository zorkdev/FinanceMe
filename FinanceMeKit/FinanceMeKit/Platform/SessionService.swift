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
        #if DEBUG
        setupForTesting()
        #endif
    }

    func save(session: Session) -> Result<Void, Error> {
        session.save(dataService: dataService)
    }

    func logOut() {
        dataService.removeAll()
    }
}

#if DEBUG
extension Stub {
    class StubSessionService: SessionService {
        let hasSession = true
        let session: Session? = nil
        func save(session: Session) -> Result<Void, Error> { .success(()) }
        func logOut() {}
    }
}

extension DefaultSessionService {
    func setupForTesting(isTesting: Bool = isTesting,
                         isLoggedIn: Bool = isLoggedIn,
                         isLoggedOut: Bool = isLoggedOut) {
        if isTesting, isLoggedIn {
            let bundle = Bundle(for: Self.self)
            guard let configURL = bundle.url(forResource: "TestSession", withExtension: "json"),
                let data = try? Data(contentsOf: configURL),
                let session = try? Session(from: data) else { return }
            _ = save(session: session)
        }

        if isTesting, isLoggedOut { logOut() }
    }
}
#endif
