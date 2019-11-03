public class AppState: ObservableObject {
    let networkService: NetworkService
    let sessionService: SessionService
    let dataService: DataService
    let loggingService: LoggingService
    let configService: ConfigService

    let complicationBusinessLogic: ComplicationBusinessLogicType
    let pushNotificationBusinessLogic: PushNotificationBusinessLogicType

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

        sessionBusinessLogic = SessionBusinessLogic(networkService: networkService, sessionService: sessionService)
        userBusinessLogic = UserBusinessLogic(networkService: networkService, dataService: dataService)
        complicationBusinessLogic = ComplicationBusinessLogic(businessLogic: userBusinessLogic)
        pushNotificationBusinessLogic = PushNotificationBusinessLogic(networkService: networkService,
                                                                      sessionService: sessionService,
                                                                      businessLogic: userBusinessLogic)
    }

    init(networkService: NetworkService,
         sessionService: SessionService,
         dataService: DataService,
         loggingService: LoggingService,
         configService: ConfigService,
         sessionBusinessLogic: SessionBusinessLogicType,
         userBusinessLogic: UserBusinessLogicType,
         complicationBusinessLogic: ComplicationBusinessLogicType,
         pushNotificationBusinessLogic: PushNotificationBusinessLogicType) {
        self.networkService = networkService
        self.sessionService = sessionService
        self.dataService = dataService
        self.loggingService = loggingService
        self.configService = configService
        self.sessionBusinessLogic = sessionBusinessLogic
        self.userBusinessLogic = userBusinessLogic
        self.complicationBusinessLogic = complicationBusinessLogic
        self.pushNotificationBusinessLogic = pushNotificationBusinessLogic
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
                        sessionBusinessLogic: Stub.StubSessionBusinessLogic(),
                        userBusinessLogic: Stub.StubUserBusinessLogic(),
                        complicationBusinessLogic: Stub.StubComplicationBusinessLogic(),
                        pushNotificationBusinessLogic: Stub.StubPushNotificationBusinessLogic())
    }
}
#endif
