import LocalAuthentication

public class AppState: ObservableObject {
    let networkService: NetworkService
    let sessionService: SessionService
    let dataService: DataService
    let loggingService: LoggingService
    let configService: ConfigService
    let authenticationService: AuthenticationService

    public let sessionBusinessLogic: SessionBusinessLogicType
    public let userBusinessLogic: UserBusinessLogicType
    public let transactionBusinessLogic: TransactionBusinessLogicType

    public init() {
        configService = DefaultConfigService()
        loggingService = DefaultLoggingService(configService: configService)
        dataService = KeychainDataService(configService: configService)
        sessionService = DefaultSessionService(dataService: dataService)
        networkService = DefaultNetworkService(networkRequestable: URLSession.shared,
                                               loggingService: loggingService,
                                               sessionService: sessionService)
        authenticationService = LAContextAuthenticationService(sessionService: sessionService,
                                                               laContextType: LAContext.self)

        sessionBusinessLogic = SessionBusinessLogic(networkService: networkService, sessionService: sessionService)
        userBusinessLogic = UserBusinessLogic(networkService: networkService, dataService: dataService)
        transactionBusinessLogic = TransactionBusinessLogic(networkService: networkService, dataService: dataService)
    }

    init(networkService: NetworkService,
         sessionService: SessionService,
         dataService: DataService,
         loggingService: LoggingService,
         configService: ConfigService,
         authenticationService: AuthenticationService,
         sessionBusinessLogic: SessionBusinessLogicType,
         userBusinessLogic: UserBusinessLogicType,
         transactionBusinessLogic: TransactionBusinessLogicType) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.dataService = dataService
        self.loggingService = loggingService
        self.configService = configService
        self.authenticationService = authenticationService
        self.sessionBusinessLogic = sessionBusinessLogic
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
    }
}

#if DEBUG
public extension AppState {
    static var stub: AppState {
        return AppState(networkService: Stub.StubNetworkService(),
                        sessionService: Stub.StubSessionService(),
                        dataService: Stub.StubDataService(),
                        loggingService: Stub.StubLoggingService(),
                        configService: Stub.StubConfigService(),
                        authenticationService: Stub.StubAuthenticationService(),
                        sessionBusinessLogic: Stub.StubSessionBusinessLogic(),
                        userBusinessLogic: Stub.StubUserBusinessLogic(),
                        transactionBusinessLogic: Stub.StubTransactionBusinessLogic())
    }
}
#endif
