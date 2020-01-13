extension NumberFormatter {
    func string(from double: Double) -> String {
        string(from: NSNumber(value: double))!
    }

    #if os(iOS) || os(macOS)
    func double(from string: String) -> Double? {
        number(from: string)?.doubleValue
    }
    #endif
}
