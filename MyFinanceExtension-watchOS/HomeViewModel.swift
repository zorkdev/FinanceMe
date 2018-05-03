import MyFinanceKit

struct HomeDisplayModel: TodayDisplayModelType {

    static let positiveColor = UIColor.white
    static let negativeColor = UIColor.red
    static let largeFontSize: CGFloat = 36
    static let smallFontSize: CGFloat = 16

}

class HomeViewModel: TodayViewModel {

    let complicationService: ComplicationServiceType

    init(serviceProvider: TodayPresentable.ServiceProvider,
         complicationService: ComplicationServiceType,
         displayModel: TodayDisplayModelType) {
        self.complicationService = complicationService
        super.init(serviceProvider: serviceProvider, displayModel: displayModel)
    }

    @discardableResult public func getUser() -> Promise<Void> {
        return super.getUser().done {
            guard let user = User.load(dataService: self.serviceProvider.dataService) else { return }
            self.complicationService.updateComplication(allowance: user.allowance)
        }
    }

}
