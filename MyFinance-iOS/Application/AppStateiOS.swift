protocol WatchServiceProvider {
    var watchService: WatchService { get }
}

typealias NetworkDataWatchServiceProvider = NetworkDataServiceProvider & WatchServiceProvider

class AppStateiOS: AppState {

    let watchService: WatchService

    init(networkService: NetworkServiceType = NetworkService(networkRequestable: URLSession.shared,
                                                             configService: ConfigFileService()),
         dataService: DataService = KeychainDataService(),
         watchService: WatchService = WatchService(dataService: KeychainDataService())) {
        self.watchService = watchService
        super.init(networkService: networkService,
                   dataService: dataService)
    }
}

extension AppStateiOS: WatchServiceProvider {}
