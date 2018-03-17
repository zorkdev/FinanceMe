struct SettingsDisplayModel {

    static let buttonEnabledAlpha: CGFloat = 1.0
    static let buttonDisabledAlpha: CGFloat = 0.5
    static let buttonAnimationDuration = 0.2
    static let editButtonTitle = "Edit"
    static let cancelButtonTitle = "Cancel"
    static let saveButtonTitle = "Save"
    static let logOutButtonTitle = "Log Out"
    static let successMessage = "Your settings have been updated!"

    let name: String
    let largeTransaction: String
    let payday: String
    let startDate: Date

    static func dateString(from date: Date) -> String {
        return Formatters.date.string(from: date)
    }

}
