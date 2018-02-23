class AppStatemacOS: AppState {

    override init() {
        let networkService = NetworkService(networkRequestable: URLSession.shared,
                                            configService: ConfigFileService())
        let dataService = UserDefaultsDataService()
        super.init(networkService: networkService,
                   dataService: dataService)
    }

}
