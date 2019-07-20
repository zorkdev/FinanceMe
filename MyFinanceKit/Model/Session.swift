public struct Session: Storeable, Equatable {
    enum CodingKeys: String, CodingKey {
        case starlingToken = "sToken"
        case zorkdevToken = "token"
    }

    let starlingToken: String
    let zorkdevToken: String
}
