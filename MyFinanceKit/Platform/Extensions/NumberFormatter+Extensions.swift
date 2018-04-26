public extension NumberFormatter {

    func string(from number: Double) -> String {
        return string(from: NSNumber(value: number))!
    }

}
