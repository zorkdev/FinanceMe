#if os(macOS)
    import Cocoa

    public typealias Color = NSColor
    public typealias Font = NSFont

#elseif os(iOS)
    import UIKit

    public typealias Color = UIColor
    public typealias Font = UIFont
#endif

public protocol TodayDisplayModelType {

    var defaultAmount: String { get }
    var positiveColor: Color { get }
    var negativeColor: Color { get }
    var largeFontSize: CGFloat { get }
    var smallFontSize: CGFloat { get }

    func amountAttributedString(from string: String) -> NSAttributedString

}

public extension TodayDisplayModelType {

    var defaultAmount: String { return "\(Formatters.currencySymbol)0.00" }

    func amountAttributedString(from string: String) -> NSAttributedString {
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
