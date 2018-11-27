@testable import MyFinance_iOS

class MockPushNotificationService: PushNotificationService {

    //swiftlint:disable weak_delegate
    var delegate: PushNotificationServiceDelegate?

    func registerForNotifications() {}

}
