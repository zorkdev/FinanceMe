import LocalAuthentication
import MetricKit

public class AppState: ObservableObject {
    let networkService: NetworkService
    let sessionService: SessionService
    let dataService: DataService
    let loggingService: LoggingService
    let configService: ConfigService
    let metricService: MetricService
    let authenticationService: AuthenticationService

    public let sessionBusinessLogic: SessionBusinessLogicType
    public let userBusinessLogic: UserBusinessLogicType
    public let transactionBusinessLogic: TransactionBusinessLogicType
    public let summaryBusinessLogic: SummaryBusinessLogicType
    public let authenticationBusinessLogic: AuthenticationBusinessLogicType

    public init() {
        configService = DefaultConfigService()
        loggingService = DefaultLoggingService(configService: configService)
        dataService = KeychainDataService(configService: configService)
        sessionService = DefaultSessionService(dataService: dataService)
        networkService = DefaultNetworkService(networkRequestable: URLSession.shared,
                                               loggingService: loggingService,
                                               sessionService: sessionService)
        metricService = DefaultMetricService(networkService: networkService, metricManager: MXMetricManager.shared)
        authenticationService = LAContextAuthenticationService(sessionService: sessionService,
                                                               laContextType: LAContext.self)

        sessionBusinessLogic = SessionBusinessLogic(networkService: networkService, sessionService: sessionService)
        userBusinessLogic = UserBusinessLogic(networkService: networkService, dataService: dataService)
        transactionBusinessLogic = TransactionBusinessLogic(networkService: networkService, dataService: dataService)
        summaryBusinessLogic = SummaryBusinessLogic(networkService: networkService, dataService: dataService)
        authenticationBusinessLogic = AuthenticationBusinessLogic(authenticationService: authenticationService)
    }

    init(networkService: NetworkService,
         sessionService: SessionService,
         dataService: DataService,
         loggingService: LoggingService,
         configService: ConfigService,
         metricService: MetricService,
         authenticationService: AuthenticationService,
         sessionBusinessLogic: SessionBusinessLogicType,
         userBusinessLogic: UserBusinessLogicType,
         transactionBusinessLogic: TransactionBusinessLogicType,
         summaryBusinessLogic: SummaryBusinessLogicType,
         authenticationBusinessLogic: AuthenticationBusinessLogicType) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.dataService = dataService
        self.loggingService = loggingService
        self.configService = configService
        self.metricService = metricService
        self.authenticationService = authenticationService
        self.sessionBusinessLogic = sessionBusinessLogic
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
        self.authenticationBusinessLogic = authenticationBusinessLogic
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
                        metricService: Stub.StubMetricService(),
                        authenticationService: Stub.StubAuthenticationService(),
                        sessionBusinessLogic: Stub.StubSessionBusinessLogic(),
                        userBusinessLogic: Stub.StubUserBusinessLogic(),
                        transactionBusinessLogic: Stub.StubTransactionBusinessLogic(),
                        summaryBusinessLogic: Stub.StubSummaryBusinessLogic(),
                        authenticationBusinessLogic: Stub.StubAuthenticationBusinessLogic())
    }
}
#endif
