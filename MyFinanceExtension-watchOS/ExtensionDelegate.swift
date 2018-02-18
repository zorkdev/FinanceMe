import WatchKit
import WatchConnectivity
import MyFinanceKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    private var session: WCSession?

    let appState = AppState()

    override init() {
        super.init()

        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

}

extension ExtensionDelegate: WCSessionDelegate {

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        guard let allowanceValue = userInfo[Allowance.instanceName] as? Double,
            let activeComplications = CLKComplicationServer.sharedInstance().activeComplications else { return }
        let allowance = Allowance(allowance: allowanceValue)
        allowance.save(dataService: appState.dataService)

        for complication in activeComplications {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
    }

}
