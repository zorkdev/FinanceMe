extension Data {

    var prettyPrinted: String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []),
            let prettyPrintedJSON = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let jsonString = String(data: prettyPrintedJSON, encoding: .utf8) {
            let cleanJSONString = jsonString.replacingOccurrences(of: "\\", with: "")
            return cleanJSONString
        } else {
            return "nil"
        }
    }

}
