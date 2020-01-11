public class AppState: ObservableObject {
    let networkService: NetworkService
    let sessionService: SessionService
    let dataService: DataService
    let loggingService: LoggingService
    let configService: ConfigService

    let sessionBusinessLogic: SessionBusinessLogicType
    let userBusinessLogic: UserBusinessLogicType

    public init() {
        configService = DefaultConfigService()
        loggingService = DefaultLoggingService(configService: configService)
        dataService = KeychainDataService(configService: configService)
        sessionService = DefaultSessionService(dataService: dataService)
        networkService = DefaultNetworkService(networkRequestable: URLSession.shared,
                                               loggingService: loggingService,
                                               sessionService: sessionService)

        sessionBusinessLogic = SessionBusinessLogic(networkService: networkService, sessionService: sessionService)
        userBusinessLogic = UserBusinessLogic(networkService: networkService, dataService: dataService)
    }

    init(networkService: NetworkService,
         sessionService: SessionService,
         dataService: DataService,
         loggingService: LoggingService,
         configService: ConfigService,
         sessionBusinessLogic: SessionBusinessLogicType,
         userBusinessLogic: UserBusinessLogicType) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.dataService = dataService
        self.loggingService = loggingService
        self.configService = configService
        self.sessionBusinessLogic = sessionBusinessLogic
        self.userBusinessLogic = userBusinessLogic
    }
}

#if DEBUG
extension AppState {
    static var stub: AppState {
        AppState(networkService: Stub.StubNetworkService(),
                 sessionService: Stub.StubSessionService(),
                 dataService: Stub.StubDataService(),
                 loggingService: Stub.StubLoggingService(),
                 configService: Stub.StubConfigService(),
                 sessionBusinessLogic: Stub.StubSessionBusinessLogic(),
                 userBusinessLogic: Stub.StubUserBusinessLogic())
    }
}
#endif
