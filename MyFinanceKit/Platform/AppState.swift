public protocol NetworkServiceProvider {
    var networkService: NetworkServiceType { get }
}

public protocol DataServiceProvider {
    var dataService: DataService { get }
}

public typealias NetworkDataServiceProvider = NetworkServiceProvider & DataServiceProvider

open class AppState {

    public let networkService: NetworkServiceType
    public let dataService: DataService

    public init(networkService: NetworkServiceType = NetworkService(networkRequestable: URLSession.shared,
                                                                    configService: ConfigFileService()),
                dataService: DataService = KeychainDataService()) {
        self.networkService = networkService
        self.dataService = dataService
    }

}

extension AppState: NetworkDataServiceProvider {}
