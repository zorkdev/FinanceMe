extension Dictionary {

    var urlQuery: String {
        var parameters = [String]()

        for (key, value) in self {
            let valueString = "\(value)"
            let keyString = "\(key)"
            guard let encodedValueString =
                valueString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                break
            }
            parameters.append(keyString + "=" + encodedValueString)
        }

        let urlQueryString = parameters.joined(separator: "&")

        return "?" + urlQueryString
    }

    var prettyPrinted: String {
        guard let prettyPrintedJSON = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let jsonString = String(data: prettyPrintedJSON, encoding: .utf8) else {
                return "nil"
        }

        let cleanJSONString = jsonString.replacingOccurrences(of: "\\", with: "")

        return cleanJSONString
    }

}
