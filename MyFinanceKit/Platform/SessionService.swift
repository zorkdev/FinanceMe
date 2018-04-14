public protocol SessionService {
    var hasSession: Bool { get }
    func getSession() -> Session?
    func save(session: Session)
}

public class SessionDefaultService: SessionService {

    let dataService: DataService

    public var hasSession: Bool {
        return getSession() != nil
    }

    public init(dataService: DataService) {
        self.dataService = dataService
    }

    public func getSession() -> Session? {
        return Session.load(dataService: dataService)
    }

    public func save(session: Session) {
        session.save(dataService: dataService)
    }

}

public class SessionFileService: SessionDefaultService {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
    }

    public override init(dataService: DataService) {
        super.init(dataService: dataService)

        if Session.load(dataService: dataService) == nil { loadSessionFromBundle() }
    }

    private func loadSessionFromBundle() {
        let bundle = Bundle(for: SessionFileService.self)

        guard let configURL = bundle.url(forResource: Constants.configFilename,
                                         withExtension: Constants.configExtension),
            let data = try? Data(contentsOf: configURL),
            let session = Session(data: data) else { return }

        session.save(dataService: dataService)
    }

}
