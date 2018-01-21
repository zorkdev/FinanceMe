struct Config: Codable {

    let inbound: [String: Double]
    let outbound: [String: Double]

    let token: String
    let payday: Int

}
