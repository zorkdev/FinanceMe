@testable import MyFinanceKit

class MockSessionService: SessionService {
    var hasSessionReturnValue = false
    var getSessionReturnValue: Session?
    var lastSaveValue: Session?

    var hasSession: Bool {
        return hasSessionReturnValue
    }

    func getSession() -> Session? {
        return getSessionReturnValue
    }

    func save(session: Session) {
        lastSaveValue = session
    }
}
