protocol WatchServiceProvider {
    var watchService: WatchService { get }
}

typealias NetworkDataWatchServiceProvider = NetworkDataServiceProvider & WatchServiceProvider

class AppStateiOS: AppState {

    let watchService: WatchService

    override init() {
        self.watchService = WatchService(dataService: KeychainDataService())
        super.init()
    }

}

extension AppStateiOS: WatchServiceProvider {}
