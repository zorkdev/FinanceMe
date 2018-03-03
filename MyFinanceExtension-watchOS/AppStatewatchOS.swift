import WatchConnectivity
import MyFinanceKit

protocol ComplicationServiceProvider {

    var complicationService: ComplicationServiceType { get }

}

protocol AppStatewatchOSType: AppStateType & ComplicationServiceProvider {}

class AppStatewatchOS: AppState, AppStatewatchOSType {

    let complicationService: ComplicationServiceType

    override init() {
        let keychainDataService = KeychainDataService(configService: ConfigDefaultService())
        self.complicationService = ComplicationService(wcSession: WCSession.default,
                                                       dataService: keychainDataService)
        super.init()
    }

}
