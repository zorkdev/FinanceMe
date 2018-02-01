struct TodayDisplayModel: TodayDisplayModelType {

    let defaultAmount = "£0.00"

    func amountAttributedString(from string: String) -> NSAttributedString {
        let isNegative = string.first == "-"
        let color = isNegative ? UIColor.red : UIColor.darkText

        let attributedString = NSMutableAttributedString(string: string, attributes:
            [.font: UIFont.systemFont(ofSize: 40, weight: .light),
             .foregroundColor: color])
        let length = isNegative ? 2 : 1
        attributedString.addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .regular)],
            range: NSRange(location: 0, length: length))
        attributedString.addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .regular)],
            range: NSRange(location: string.count - 3, length: 3))

        return attributedString
    }

}
