@testable import MyFinance_iOS

class MockWatchService: WatchServiceType {
    var didCallUpdateComplication = false

    init() {}

    required init(wcSession: WCSessionType,
                  dataService: DataService,
                  pushNotificationService: PushNotificationService) {}

    func updateComplication() {
        didCallUpdateComplication = true
    }
}
