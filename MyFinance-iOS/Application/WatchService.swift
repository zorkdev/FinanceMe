import WatchConnectivity

class WatchService: NSObject {

    private let dataService: DataService
    private var session: WCSession?

    init(dataService: DataService) {
        self.dataService = dataService

        super.init()

        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func updateComplication() {
        guard session?.activationState == .activated,
            session?.isComplicationEnabled == true,
            let user = User.load(dataService: dataService) else { return }

        let previousAllowance: Allowance? = Allowance.load(dataService: dataService)
        guard user.allowance != previousAllowance?.allowance else { return }
        let allowance = Allowance(allowance: user.allowance)
        let data = [Allowance.instanceName: allowance.allowance]
        session?.transferCurrentComplicationUserInfo(data)
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
