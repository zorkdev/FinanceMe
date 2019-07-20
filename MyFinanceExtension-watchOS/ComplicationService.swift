import WatchConnectivity
import MyFinanceKit

protocol WCSessionType {
    static func isSupported() -> Bool

    var delegate: WCSessionDelegate? { get set }

    func activate()
}

extension WCSession: WCSessionType {}

protocol ComplicationServiceType {
    init(wcSession: WCSessionType, dataService: DataService)
    func updateComplication(allowance: Double)
}

class ComplicationService: NSObject, ComplicationServiceType {
    private let dataService: DataService
    private var session: WCSessionType?

    required init(wcSession: WCSessionType, dataService: DataService) {
        self.session = wcSession
        self.dataService = dataService

        super.init()

        self.session?.delegate = self

        if type(of: wcSession).isSupported() { session?.activate() }
    }

    func updateComplication(allowance: Double) {
        let allowanceInstance = Allowance(allowance: allowance)
        allowanceInstance.save(dataService: dataService)

        guard let activeComplications = CLKComplicationServer.sharedInstance().activeComplications else { return }
        for complication in activeComplications {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
    }
}

extension ComplicationService: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        guard let allowance = userInfo[Allowance.instanceName] as? Double else { return }
        updateComplication(allowance: allowance)
    }
}
