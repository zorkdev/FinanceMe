import WatchConnectivity

protocol WatchServiceProvider {

    var watchService: WatchServiceType { get }

}

class AppStateiOS: AppState {

    let watchService: WatchServiceType

    override init() {
        self.watchService = WatchService(wcSession: WCSession.default,
                                         dataService: KeychainDataService())
        super.init()
    }

}

extension AppStateiOS: WatchServiceProvider {}
