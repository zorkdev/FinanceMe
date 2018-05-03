public protocol TodayDisplayModelType {

    static var defaultAmount: String { get }
    static var positiveColor: Color { get }
    static var negativeColor: Color { get }
    static var largeFontSize: CGFloat { get }
    static var smallFontSize: CGFloat { get }

    static func amountAttributedString(from string: String) -> NSAttributedString

}

public extension TodayDisplayModelType {

    static var defaultAmount: String { return "\(Formatters.currencySymbol)0.00" }

    static func amountAttributedString(from string: String) -> NSAttributedString {
        let isNegative = string.first == "-"
        let color = isNegative ? negativeColor : positiveColor

        let attributedString = NSMutableAttributedString(string: string, attributes:
            [.font: Font.systemFont(ofSize: largeFontSize, weight: .light),
             .foregroundColor: color])
        let length = isNegative ? 2 : 1
        attributedString.addAttributes(
            [.font: Font.systemFont(ofSize: smallFontSize, weight: .regular)],
            range: NSRange(location: 0, length: length))
        attributedString.addAttributes(
            [.font: Font.systemFont(ofSize: smallFontSize, weight: .regular)],
            range: NSRange(location: string.count - 3, length: 3))

        return attributedString
    }

}
