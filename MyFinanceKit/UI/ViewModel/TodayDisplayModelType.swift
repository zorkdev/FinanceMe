public protocol TodayDisplayModelType {

    static var defaultAmount: String { get }
    static var positiveColor: Color { get }
    static var negativeColor: Color { get }
    static var largeFontSize: CGFloat { get }
    static var smallFontSize: CGFloat { get }
    static var formatter: NumberFormatter { get }

    static func attributedString(from amount: Double) -> NSAttributedString

}

public extension TodayDisplayModelType {

    static var defaultAmount: String { return "\(Formatters.currencySymbol)0.00" }

    static var formatter: NumberFormatter { return Formatters.currency }

    static func attributedString(from amount: Double) -> NSAttributedString {
        let string = formatter.string(from: amount)
        let location = string.firstIndex { CharacterSet.decimalDigits.contains($0.unicodeScalars.first!) }

        guard let length = location?.encodedOffset else { return NSAttributedString(string: string) }

        let isNegative = amount < 0
        let color = isNegative ? negativeColor : positiveColor

        let attributedString = NSMutableAttributedString(string: string, attributes:
            [.font: Font.systemFont(ofSize: largeFontSize, weight: .light),
             .foregroundColor: color])
        attributedString.addAttributes(
            [.font: Font.systemFont(ofSize: smallFontSize, weight: .regular)],
            range: NSRange(location: 0, length: length))
        attributedString.addAttributes(
            [.font: Font.systemFont(ofSize: smallFontSize, weight: .regular)],
            range: NSRange(location: string.count - 3, length: 3))

        return attributedString
    }

}
