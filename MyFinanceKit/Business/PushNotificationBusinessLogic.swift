public struct PushNotificationBusinessLogic {
    private let networkService: NetworkService

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    @discardableResult
    public func create(deviceToken: DeviceToken) -> Promise<Void> {
        return networkService
            .performRequest(api: API.zorkdev(.deviceToken),
                            method: .post,
                            parameters: nil,
                            body: deviceToken).asVoid()
    }
}
