struct TodayDisplayModel: TodayDisplayModelType {

    let defaultAmount = "£0.00"

    let positiveColor = NSColor(srgbRed: 62/255.0, green: 62/255.0, blue: 62/255.0, alpha: 1.0)

    func amountAttributedString(from string: String) -> NSAttributedString {
        let isNegative = string.first == "-"
        let color = isNegative ? NSColor.red.withAlphaComponent(0.8) : positiveColor

        let attributedString = NSMutableAttributedString(string: string, attributes:
            [.font: NSFont.systemFont(ofSize: 34, weight: .light),
             .foregroundColor: color])
        let length = isNegative ? 2 : 1
        attributedString.addAttributes(
            [.font: NSFont.systemFont(ofSize: 13, weight: .regular)],
            range: NSRange(location: 0, length: length))
        attributedString.addAttributes(
            [.font: NSFont.systemFont(ofSize: 13, weight: .regular)],
            range: NSRange(location: string.count - 3, length: 3))

        return attributedString
    }

}
