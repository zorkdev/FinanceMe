@testable import FinanceMeKit

public enum Factory {
    public static func makeSession() -> Session {
        Session(sToken: "sToken",
                token: "token")
    }
}
