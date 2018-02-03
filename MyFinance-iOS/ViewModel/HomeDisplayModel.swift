struct HomeDisplayModel: TodayDisplayModelType {

    func amountAttributedString(from string: String) -> NSAttributedString {
        let isNegative = string.first == "-"
        let positiveColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
        let negativeColor = UIColor(red: 205/255.0, green: 65/255.0, blue: 75/255.0, alpha: 1.0)
        let color = isNegative ? negativeColor : positiveColor

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
