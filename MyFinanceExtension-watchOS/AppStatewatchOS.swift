import WatchConnectivity
import MyFinanceKit

protocol ComplicationServiceProvider {

    var complicationService: ComplicationServiceType { get }

}

protocol AppStatewatchOSType: AppStateType & ComplicationServiceProvider {}

class AppStatewatchOS: AppState, AppStatewatchOSType {

    let complicationService: ComplicationServiceType

    override init() {
        self.complicationService = ComplicationService(wcSession: WCSession.default,
                                                       dataService: KeychainDataService())
        super.init()
    }

}
