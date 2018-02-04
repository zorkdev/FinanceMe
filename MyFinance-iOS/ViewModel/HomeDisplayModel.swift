struct HomeDisplayModel: TodayDisplayModelType {

    let positiveColor = UIColor(red: 245/255.0,
                                green: 245/255.0,
                                blue: 255/255.0,
                                alpha: 1)
    let negativeColor = UIColor(red: 205/255.0,
                                green: 65/255.0,
                                blue: 75/255.0,
                                alpha: 1)
    let largeFontSize: CGFloat = 40
    let smallFontSize: CGFloat = 16

    static let regularInboundSectionTitle = "Incoming"
    static let regularOutboundSectionTitle = "Outgoing"
    static let currentMonthTitle = "This month remaining"

    struct DeleteAlert {

        static let title = "Are you sure?"
        static let message = "The transaction will be deleted."
        static let confirmButtonTitle = "Delete"
        static let cancelButtonTitle = "Cancel"

    }

}
