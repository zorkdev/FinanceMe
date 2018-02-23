protocol WatchServiceProvider {
    var watchService: WatchService { get }
}

class AppStateiOS: AppState {

    let watchService: WatchService

    override init() {
        self.watchService = WatchService(dataService: KeychainDataService())
        super.init()
    }

}

extension AppStateiOS: WatchServiceProvider {}
