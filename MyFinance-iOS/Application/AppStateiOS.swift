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

    let navigator: NavigatorType
    let watchService: WatchServiceType
    let laContext: LAContextType

    override init() {
        let keychainDataService = KeychainDataService(configService: ConfigDefaultService())
        self.navigator = Navigator(window: UIWindow())
        self.watchService = WatchService(wcSession: WCSession.default,
                                         dataService: keychainDataService)
        self.laContext = LAContext()
        super.init()
    }

}
