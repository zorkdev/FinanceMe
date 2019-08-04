import FinanceMeKit

public class MockSessionService: SessionService {
    public var hasSession: Bool = false
    public var session: Session?

    public init() {}

    public var lastSaveValue: Session?
    public func save(session: Session) {
        lastSaveValue = session
    }

    public var didCallLogOut = false
    public func logOut() {
        didCallLogOut = true
    }
}
