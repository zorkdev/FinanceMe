public protocol NetworkServiceProvider {

    var networkService: NetworkServiceType { get }

}

public protocol DataServiceProvider {

    var dataService: DataService { get }

}

public protocol SessionServiceProvider {

    var sessionService: SessionService { get }

}

public protocol AppStateType: class, NetworkServiceProvider & DataServiceProvider & SessionServiceProvider {}

open class AppState: AppStateType {

    public let networkService: NetworkServiceType
    public let dataService: DataService
    public let configService: ConfigService
    public let sessionService: SessionService

    public init() {
        configService = ConfigDefaultService()
        dataService = KeychainDataService(configService: configService)
        sessionService = SessionFileService(dataService: dataService)
        networkService = NetworkService(networkRequestable: URLSession.shared,
                                        configService: configService,
                                        sessionService: sessionService)
    }

    public init(networkService: NetworkServiceType,
                dataService: DataService,
                configService: ConfigService,
                sessionService: SessionService) {
        self.networkService = networkService
        self.dataService = dataService
        self.configService = configService
        self.sessionService = sessionService
    }

}
