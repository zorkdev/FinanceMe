import WatchConnectivity

protocol WCSessionType {

    static func isSupported() -> Bool

    var delegate: WCSessionDelegate? { get set }
    var activationState: WCSessionActivationState { get }
    var isComplicationEnabled: Bool { get }

    func activate()
    func transferCurrentComplicationUserInfo(_ userInfo: [String: Any]) -> WCSessionUserInfoTransfer

}

extension WCSession: WCSessionType {}

protocol WatchServiceType {

    init(wcSession: WCSessionType,
         dataService: DataService,
         pushNotificationService: PushNotificationService)
    func updateComplication()

}

class WatchService: NSObject, WatchServiceType {

    private let dataService: DataService
    private var session: WCSessionType?

    required init(wcSession: WCSessionType,
                  dataService: DataService,
                  pushNotificationService: PushNotificationService) {
        self.session = wcSession
        self.dataService = dataService

        super.init()

        self.session?.delegate = self
        pushNotificationService.delegate = self

        if type(of: wcSession).isSupported() { session?.activate() }
    }

    func updateComplication() {
        guard session?.activationState == .activated,
            session?.isComplicationEnabled == true,
            let user = User.load(dataService: dataService) else { return }

        let previousAllowance: Allowance? = Allowance.load(dataService: dataService)
        guard user.allowance != previousAllowance?.allowance else { return }
        let allowance = Allowance(allowance: user.allowance)
        let data = [Allowance.instanceName: allowance.allowance]
        _ = session?.transferCurrentComplicationUserInfo(data)
        allowance.save(dataService: dataService)
    }

}

extension WatchService: WCSessionDelegate {

    public func session(_ session: WCSession,
                        activationDidCompleteWith activationState: WCSessionActivationState,
                        error: Error?) {}
    public func sessionDidBecomeInactive(_ session: WCSession) {}
    public func sessionDidDeactivate(_ session: WCSession) {}

}

extension WatchService: PushNotificationServiceDelegate {

    func didReceiveIncomingPush(payload: [AnyHashable: Any]) {
        guard let allowance = payload["allowance"] as? Double,
            var user = User.load(dataService: dataService) else { return }
        user.allowance = allowance
        user.save(dataService: dataService)
        updateComplication()
    }

}
