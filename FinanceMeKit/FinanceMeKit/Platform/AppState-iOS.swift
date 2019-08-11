import LocalAuthentication

public protocol AppStateType: AnyObject,
NetworkServiceProvider
& SessionServiceProvider
& DataServiceProvider
& LoggingServiceProvider
& ConfigServiceProvider
& AuthenticationServiceProvider {}

public class AppState: AppStateType {
    public let networkService: NetworkService
    public let sessionService: SessionService
    public let dataService: DataService
    public let loggingService: LoggingService
    public let configService: ConfigService
    public let authenticationService: AuthenticationService

    public init(authReason: String) {
        configService = DefaultConfigService()
        loggingService = DefaultLoggingService(configService: configService)
        dataService = KeychainDataService(configService: configService)
        sessionService = DefaultSessionService(dataService: dataService)
        networkService = DefaultNetworkService(networkRequestable: URLSession.shared,
                                               loggingService: loggingService,
                                               sessionService: sessionService)
        authenticationService = LAContextAuthenticationService(sessionService: sessionService,
                                                               laContextType: LAContext.self,
                                                               reason: authReason)
    }
}
