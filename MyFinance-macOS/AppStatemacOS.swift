class AppStatemacOS: AppState {

    override init() {
        let fatalErrorable = SwiftFatalError()
        let configService = ConfigFileService(fatalErrorable: fatalErrorable)!
        let networkService = NetworkService(networkRequestable: URLSession.shared,
                                        configService: configService)
        let dataService = KeychainDataService()
        super.init(networkService: networkService,
                   dataService: dataService)
    }

}
