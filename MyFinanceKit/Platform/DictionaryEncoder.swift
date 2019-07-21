import Foundation

public class URLFormEncoder {
    private let dateFormatter: DateFormatter

    public init(dateFormatter: DateFormatter = Formatters.apiDateTime) {
        self.dateFormatter = dateFormatter
    }

    public func encode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let encoder = InternalDictionaryEncoder(dateFormatter: dateFormatter)
        try value.encode(to: encoder)
        let queryItems = encoder.container.value.map { URLQueryItem(name: $0.key, value: $0.value) }

        return queryItems
    }
}

private class InternalDictionaryEncoder: Encoder {
    var codingPath = [CodingKey]()
    var userInfo = [CodingUserInfoKey: Any]()
    var container = DictionaryContainer()
    let dateFormatter: DateFormatter

    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        return KeyedEncodingContainer(DictionaryKeyedEncodingContainer<Key>(referencing: self,
                                                                            wrapping: container))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return ThrowingUnkeyedEncodingContainer(referencing: self)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        return ThrowingSingleValueEncodingContainer()
    }
}

private class DictionaryContainer {
    var value = [String: String]()
}

private struct DictionaryKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    let codingPath = [CodingKey]()
    let encoder: InternalDictionaryEncoder
    var container: DictionaryContainer

    init(referencing encoder: InternalDictionaryEncoder, wrapping container: DictionaryContainer) {
        self.encoder = encoder
        self.container = container
    }

    func encodeNil(forKey key: Key) throws {}

    func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        switch value {
        case is Bool, is Int, is Double, is String:
            container.value[key.stringValue] = "\(value)"
        case let date as Date:
            container.value[key.stringValue] = encoder.dateFormatter.string(from: date)
        default:
            let context = EncodingError.Context(codingPath: codingPath,
                                                debugDescription: "Unsupported type.")
            throw EncodingError.invalidValue(value, context)
        }
        print(encoder.codingPath)
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type,
                                    forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        return KeyedEncodingContainer(ThrowingNestedKeyedEncodingContainer<NestedKey>(referencing: encoder))
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }

    func superEncoder() -> Encoder {
        return encoder
    }

    func superEncoder(forKey key: Key) -> Encoder {
        return encoder
    }
}

private struct ThrowingNestedKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    let codingPath = [CodingKey]()
    let encoder: Encoder

    init(referencing encoder: Encoder) {
        self.encoder = encoder
    }

    func encodeNil(forKey key: Key) throws {
        let context = EncodingError.Context(codingPath: codingPath,
                                            debugDescription: "Nested keyed containers are not supported.")
        throw EncodingError.invalidValue("nil", context)
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        let context = EncodingError.Context(codingPath: codingPath,
                                            debugDescription: "Nested keyed containers are not supported.")
        throw EncodingError.invalidValue(value, context)
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type,
                                    forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        return encoder.container(keyedBy: keyType)
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }

    func superEncoder() -> Encoder {
        return encoder
    }

    func superEncoder(forKey key: Key) -> Encoder {
        return encoder
    }
}

private struct ThrowingUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    let codingPath = [CodingKey]()
    let encoder: Encoder
    let count = 0

    init(referencing encoder: Encoder) {
        self.encoder = encoder
    }

    func encodeNil() throws {
        let context = EncodingError.Context(codingPath: codingPath,
                                            debugDescription: "Unkeyed containers are not supported.")
        throw EncodingError.invalidValue("nil", context)
    }

    func encode<T>(_ value: T) throws where T: Encodable {
        let context = EncodingError.Context(codingPath: codingPath,
                                            debugDescription: "Unkeyed containers are not supported.")
        throw EncodingError.invalidValue(value, context)
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type)
        -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            return encoder.container(keyedBy: keyType)
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }

    func superEncoder() -> Encoder {
        return encoder
    }
}

private struct ThrowingSingleValueEncodingContainer: SingleValueEncodingContainer {
    let codingPath = [CodingKey]()

    func encodeNil() throws {
        let context = EncodingError.Context(codingPath: codingPath,
                                            debugDescription: "Single value containers are not supported.")
        throw EncodingError.invalidValue("nil", context)
    }

    func encode<T>(_ value: T) throws where T: Encodable {
        let context = EncodingError.Context(codingPath: codingPath,
                                            debugDescription: "Single value containers are not supported.")
        throw EncodingError.invalidValue(value, context)
    }
}
