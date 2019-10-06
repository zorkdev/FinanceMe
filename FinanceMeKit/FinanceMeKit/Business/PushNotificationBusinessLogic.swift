import Combine
import PushKit

protocol PushNotificationBusinessLogicType {}

class PushNotificationBusinessLogic: NSObject, PushNotificationBusinessLogicType {
    private let networkService: NetworkService
    private let businessLogic: UserBusinessLogicType
    private let pushRegistry: PKPushRegistry
    private var cancellables: Set<AnyCancellable> = []

    init(networkService: NetworkService,
         sessionService: SessionService,
         businessLogic: UserBusinessLogicType) {
        self.networkService = networkService
        self.businessLogic = businessLogic
        self.pushRegistry = PKPushRegistry(queue: nil)
        super.init()
        pushRegistry.delegate = self

        if sessionService.hasSession {
            pushRegistry.desiredPushTypes = [.complication]
        }
    }

    func create(deviceToken: DeviceToken) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.deviceToken,
                     method: .post,
                     body: deviceToken)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func handle(pushCredentials: PKPushCredentials) {
        let token = pushCredentials.token
            .reduce(into: "") { $0 += String(format: "%02X", $1) }
            .uppercased()
        let deviceToken = DeviceToken(deviceToken: token)

        create(deviceToken: deviceToken)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }
}

extension PushNotificationBusinessLogic: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {
        handle(pushCredentials: pushCredentials)
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {
        businessLogic.getUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { completion() })
            .store(in: &cancellables)
    }
}

#if DEBUG
extension Stub {
    class StubPushNotificationBusinessLogic: PushNotificationBusinessLogicType {}
}
#endif
