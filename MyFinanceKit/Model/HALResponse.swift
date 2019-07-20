struct HALResponse<T: JSONCodable>: JSONCodable, Equatable where T: Equatable {
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    let embedded: T
}
