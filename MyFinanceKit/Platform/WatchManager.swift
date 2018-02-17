import WatchConnectivity

public class WatchManager: NSObject {

    private struct Constants {
        static let allowanceKey = "allowance"
    }

    public static let shared = WatchManager()

    private let dataService = KeychainDataService()
    private var session: WCSession?

    override init() {
        super.init()

        if WCSession.isSupported() {
            session = WCSession.default
            session?.activate()
        }
    }

    func updateComplication() {
        guard session?.activationState == .activated,
            session?.isComplicationEnabled == true,
            let user = User.load(),
            let allowanceString = Formatters.currency
                .string(from: NSNumber(value: user.allowance)) else { return }

        let previousAllowance: Double? = dataService.load(key: Constants.allowanceKey)
        guard user.allowance != previousAllowance else { return }

        let data = [Constants.allowanceKey: allowanceString]
        session?.transferCurrentComplicationUserInfo(data)

        dataService.save(value: user.allowance, key: Constants.allowanceKey)
    }

}
