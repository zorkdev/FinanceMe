import Foundation

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

}
