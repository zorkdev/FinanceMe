public protocol NetworkServiceProvider {

    var networkService: NetworkServiceType { get }

}

public protocol DataServiceProvider {

    var dataService: DataService { get }

}

open class AppState: NetworkServiceProvider, DataServiceProvider {

    public let networkService: NetworkServiceType
    public let dataService: DataService

    public init() {
        networkService = NetworkService(networkRequestable: URLSession.shared,
                                        configService: ConfigFileService())
        dataService = KeychainDataService()
    }

    public init(networkService: NetworkServiceType,
                dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
    }

}
