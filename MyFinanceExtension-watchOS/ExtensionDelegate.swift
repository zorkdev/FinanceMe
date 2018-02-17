import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    private var session: WCSession?

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
        guard let allowance = userInfo[DataManager.Constants.allowanceKey] as? String,
            let activeComplications = CLKComplicationServer.sharedInstance().activeComplications else { return }
        DataManager.shared.allowance = allowance

        for complication in activeComplications {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
    }

}
