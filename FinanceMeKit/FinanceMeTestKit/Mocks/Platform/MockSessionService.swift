@testable import FinanceMeKit

public class MockSessionService: SessionService {
    public var hasSession: Bool = false
    public var session: Session?

    public init() {}

    public var lastSaveParam: Session?
    public var saveReturnValue: Result<Void, Error>?
    public func save(session: Session) -> Result<Void, Error> {
        lastSaveParam = session
        return saveReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
    }

    public var didCallLogOut = false
    public func logOut() {
        didCallLogOut = true
    }
}
