import MyFinanceKit

struct HomeDisplayModel: TodayDisplayModelType {

    let positiveColor = UIColor.white
    let negativeColor = UIColor.red
    let largeFontSize: CGFloat = 36
    let smallFontSize: CGFloat = 16

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
