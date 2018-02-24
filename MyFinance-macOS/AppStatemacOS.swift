class AppStatemacOS: AppState {

    override init() {
        let networkService = NetworkService(networkRequestable: URLSession.shared,
                                            configService: ConfigFileService())
        let dataService = KeychainDataService()
        super.init(networkService: networkService,
                   dataService: dataService)
    }

}
