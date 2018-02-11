import WatchConnectivity

public class WatchManager: NSObject {

    public static let shared = WatchManager()

    var session: WCSession?

    override init() {
        super.init()

        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func updateComplication(allowance: Double) {
        guard session?.activationState == .activated,
            session?.isComplicationEnabled == true,
            let user = User.load(),
            user.allowance != allowance ||
                UserDefaults.standard.bool(forKey: "didUpdateComplication") == false,
            let allowanceString = Formatters.currency
                .string(from: NSNumber(value: allowance)) else { return }
        let data = ["allowance": allowanceString]
        session?.transferCurrentComplicationUserInfo(data)

        UserDefaults.standard.set(true, forKey: "didUpdateComplication")
    }

}

extension WatchManager: WCSessionDelegate {

    public func session(_ session: WCSession,
                        activationDidCompleteWith activationState: WCSessionActivationState,
                        error: Error?) {
    }

    public func sessionDidBecomeInactive(_ session: WCSession) {

    }

    public func sessionDidDeactivate(_ session: WCSession) {

    }

}
