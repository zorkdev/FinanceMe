struct HALResponse<T: JSONCodable>: JSONCodable {

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    let embedded: T

}
