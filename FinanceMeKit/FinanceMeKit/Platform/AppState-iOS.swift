import LocalAuthentication

public protocol AppStateType: AnyObject {
    var sessionBusinessLogic: SessionBusinessLogicType { get }
    var userBusinessLogic: UserBusinessLogicType { get }
}

public class AppState: AppStateType {
    let networkService: NetworkService
    let sessionService: SessionService
    let dataService: DataService
    let loggingService: LoggingService
    let configService: ConfigService
    let authenticationService: AuthenticationService

    public let sessionBusinessLogic: SessionBusinessLogicType
    public let userBusinessLogic: UserBusinessLogicType

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

        sessionBusinessLogic = SessionBusinessLogic(networkService: networkService,
                                                    sessionService: sessionService)
        userBusinessLogic = UserBusinessLogic(networkService: networkService,
                                              dataService: dataService)
    }
}
