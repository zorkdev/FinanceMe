import WatchConnectivity
import LocalAuthentication

protocol NavigatorProvider {
    var navigator: NavigatorType { get }
}

protocol PushNotificationServiceProvider {
    var pushNotificationService: PushNotificationService { get }
}

protocol WatchServiceProvider {
    var watchService: WatchServiceType { get }
}

protocol LAContextProvider {
    var laContext: LAContextType { get }
}

protocol AppStateiOSType: AppStateType
& NavigatorProvider
& WatchServiceProvider
& LAContextProvider
& PushNotificationServiceProvider {}

class AppStateiOS: AppState, AppStateiOSType {
    var navigator: NavigatorType
    let pushNotificationService: PushNotificationService
    let watchService: WatchServiceType
    let laContext: LAContextType

    override init() {
        let configService = ConfigDefaultService()
        let dataService = KeychainDataService(configService: configService)
        let sessionService = SessionDefaultService(dataService: dataService)
        let networkService = NetworkService(networkRequestable: URLSession.shared,
                                            configService: configService,
                                            sessionService: sessionService)

        self.navigator = Navigator(window: UIWindow())
        self.pushNotificationService = PushNotificationDefaultService(networkService: networkService,
                                                                      sessionService: sessionService)
        self.watchService = WatchService(wcSession: WCSession.default,
                                         dataService: dataService,
                                         pushNotificationService: pushNotificationService)
        self.laContext = LAContext()

        super.init(networkService: networkService,
                   dataService: dataService,
                   configService: configService,
                   sessionService: sessionService)

        self.navigator.appState = self
    }
}
