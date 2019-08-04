extension Data {
    var prettyPrinted: String {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []),
            let prettyPrintedJSON = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let jsonString = String(data: prettyPrintedJSON, encoding: .utf8) else {
                return "nil"
        }
        return jsonString.replacingOccurrences(of: "\\", with: "")
    }
}
