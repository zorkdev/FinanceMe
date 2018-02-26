import WatchConnectivity
@testable import MyFinance_iOS

class MockWCSession: WCSessionType {

    static var isSupportedValue = true

    static func isSupported() -> Bool {
        return isSupportedValue
    }

    weak var delegate: WCSessionDelegate?

    var activationState: WCSessionActivationState = .notActivated
    var isComplicationEnabled: Bool = true

    var didCallActivate = false
    var lastTransfer: [String: Any]?
    var newActivationState = WCSessionActivationState.activated

    func activate() {
        didCallActivate = true
        activationState = newActivationState
    }

    func transferCurrentComplicationUserInfo(_ userInfo: [String: Any]) -> WCSessionUserInfoTransfer {
        lastTransfer = userInfo
        return WCSessionUserInfoTransfer()
    }

}
