public protocol NetworkServiceProvider {

    var networkService: NetworkServiceType { get }

}

public protocol DataServiceProvider {

    var dataService: DataService { get }

}

public protocol AppStateType: class, NetworkServiceProvider & DataServiceProvider {}

open class AppState: AppStateType {

    public let networkService: NetworkServiceType
    public let dataService: DataService
    public let configService: ConfigService

    public init() {
        configService = ConfigDefaultService()
        dataService = KeychainDataService(configService: configService)
        networkService = NetworkService(networkRequestable: URLSession.shared,
                                        dataService: dataService,
                                        configService: configService)
    }

    public init(networkService: NetworkServiceType,
                dataService: DataService,
                configService: ConfigService) {
        self.networkService = networkService
        self.dataService = dataService
        self.configService = configService
    }

}
