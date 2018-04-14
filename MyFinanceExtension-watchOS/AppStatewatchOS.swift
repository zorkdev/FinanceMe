import WatchConnectivity
import MyFinanceKit

protocol ComplicationServiceProvider {

    var complicationService: ComplicationServiceType { get }

}

protocol AppStatewatchOSType: AppStateType & ComplicationServiceProvider {}

class AppStatewatchOS: AppState, AppStatewatchOSType {

    let complicationService: ComplicationServiceType

    override init() {
        let configService = ConfigDefaultService()
        let dataService = KeychainDataService(configService: configService)
        let sessionService = SessionFileService(dataService: dataService)
        self.complicationService = ComplicationService(wcSession: WCSession.default,
                                                       dataService: dataService)
        let networkService = NetworkService(networkRequestable: URLSession.shared,
                                            configService: configService,
                                            sessionService: sessionService)

        super.init(networkService: networkService,
                   dataService: dataService,
                   configService: configService,
                   sessionService: sessionService)
    }

}
