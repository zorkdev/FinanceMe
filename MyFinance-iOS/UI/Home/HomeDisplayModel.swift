struct HomeDisplayModel: TodayDisplayModelType {
    static let positiveColor = Color(red: 245 / 255.0,
                                     green: 245 / 255.0,
                                     blue: 255 / 255.0,
                                     alpha: 1)
    static let negativeColor = Color(red: 205 / 255.0,
                                     green: 65 / 255.0,
                                     blue: 75 / 255.0,
                                     alpha: 1)
    static let largeFontSize: CGFloat = 40
    static let smallFontSize: CGFloat = 16

    static let tableViewInsets = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 58,
                                              right: 0)

    enum DeleteAlert {
        static let title = "Are you sure? 😰"
        static let message = "The transaction will be deleted."
        static let confirmButtonTitle = "Delete"
        static let cancelButtonTitle = "Cancel"
    }
}
