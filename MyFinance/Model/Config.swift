struct Config: Codable {

    let starlingToken: String
    let zorkdevToken: String
    let payday: Int
    let endOfMonthBalance: Double
    let regularInbound: [String: Double]
    let regularOutbound: [String: Double]
    let inbound: [String: Double]
    let outbound: [String: Double]

}
