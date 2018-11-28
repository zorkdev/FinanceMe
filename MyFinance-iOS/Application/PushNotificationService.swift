import PushKit

protocol PushNotificationServiceDelegate: class {

    func didReceiveIncomingPush(payload: [AnyHashable: Any])

}

protocol PushNotificationService: class {

    var delegate: PushNotificationServiceDelegate? { get set }

    func registerForNotifications()

}

class PushNotificationDefaultService: NSObject, PushNotificationService {

    private let sessionService: SessionService
    private let pushRegistry: PKPushRegistry
    private let pushNotificationBusinessLogic: PushNotificationBusinessLogic
    private var deviceToken: String?

    weak var delegate: PushNotificationServiceDelegate?

    init(networkService: NetworkService, sessionService: SessionService) {
        self.sessionService = sessionService
        self.pushNotificationBusinessLogic = PushNotificationBusinessLogic(networkService: networkService)
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        super.init()
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.complication]
    }

    func registerForNotifications() {
        guard let deviceToken = deviceToken,
            sessionService.hasSession else { return }
        pushNotificationBusinessLogic.create(deviceToken: DeviceToken(deviceToken: deviceToken))
    }

}

extension PushNotificationDefaultService: PKPushRegistryDelegate {

    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {
        let token = pushCredentials.token.reduce("", {$0 + String(format: "%02X", $1)}).uppercased()
        deviceToken = token
        registerForNotifications()
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {
        delegate?.didReceiveIncomingPush(payload: payload.dictionaryPayload)
        completion()
    }

}
