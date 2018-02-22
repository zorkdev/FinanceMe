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

    public init() {
        let fatalErrorable = SwiftFatalError()
        let configService = ConfigFileService(fatalErrorable: fatalErrorable)!
        networkService = NetworkService(networkRequestable: URLSession.shared,
                                        configService: configService)
        dataService = KeychainDataService()
    }

    public init(networkService: NetworkServiceType,
                dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
    }

}

extension AppState: NetworkDataServiceProvider {}
