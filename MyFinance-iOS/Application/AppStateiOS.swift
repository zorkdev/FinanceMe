import WatchConnectivity
import LocalAuthentication

protocol NavigatorProvider {

    var navigator: NavigatorType { get }

}

protocol WatchServiceProvider {

    var watchService: WatchServiceType { get }

}

protocol LAContextProvider {

    var laContext: LAContextType { get }

}

protocol AppStateiOSType: AppStateType & NavigatorProvider & WatchServiceProvider & LAContextProvider {}

class AppStateiOS: AppState, AppStateiOSType {

    var navigator: NavigatorType
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
        self.watchService = WatchService(wcSession: WCSession.default,
                                         dataService: dataService)
        self.laContext = LAContext()

        super.init(networkService: networkService,
                   dataService: dataService,
                   configService: configService,
                   sessionService: sessionService)

        self.navigator.appState = self
    }

}
