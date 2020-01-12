extension NumberFormatter {
    func string(from double: Double) -> String {
        string(from: NSNumber(value: double))!
    }

    func double(from string: String) -> Double? {
        number(from: string)?.doubleValue
    }
}
