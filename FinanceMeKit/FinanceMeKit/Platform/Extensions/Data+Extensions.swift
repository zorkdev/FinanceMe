extension Data {
    var utf8String: String {
        String(decoding: self, as: UTF8.self).replacingOccurrences(of: "\\", with: "")
    }

    var prettyPrinted: String {
        guard let json = try? JSONSerialization.jsonObject(with: self),
            let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                return utf8String
        }
        return data.utf8String
    }
}
