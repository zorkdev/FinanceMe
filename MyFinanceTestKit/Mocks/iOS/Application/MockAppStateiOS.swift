@testable import MyFinance_iOS

// swiftlint:disable force_cast
class MockAppStateiOS: MockAppState, AppStateiOSType {
    var watchService: WatchServiceType = MockWatchService()
    var mockWatchService: MockWatchService { return watchService as! MockWatchService }

    var laContext: LAContextType = MockLAContext()
    var mockLAContext: MockLAContext { return laContext as! MockLAContext }

    var navigator: NavigatorType = MockNavigator(window: MockWindow())
    var mockNavigator: MockNavigator { return navigator as! MockNavigator }

    var pushNotificationService: PushNotificationService = MockPushNotificationService()
    var mockPushNotificationService: MockPushNotificationService {
        return pushNotificationService as! MockPushNotificationService
    }
}
