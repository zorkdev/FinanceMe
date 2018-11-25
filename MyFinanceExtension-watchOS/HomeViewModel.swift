import MyFinanceKit

struct HomeDisplayModel: TodayDisplayModelType {

    static let positiveColor = Color.white
    static let negativeColor = Color.red
    static let largeFontSize: CGFloat = 36
    static let smallFontSize: CGFloat = 16

}

protocol HomeViewModelType: TodayPresentable {
    @discardableResult func update() -> Promise<Void>
}

class HomeViewModel: TodayViewModel, HomeViewModelType {

    let complicationService: ComplicationServiceType

    init(serviceProvider: TodayPresentable.ServiceProvider,
         complicationService: ComplicationServiceType,
         displayModel: TodayDisplayModelType) {
        self.complicationService = complicationService
        super.init(serviceProvider: serviceProvider, displayModel: displayModel)
    }

    @discardableResult func update() -> Promise<Void> {
        return updateData().done {
            guard let user = User.load(dataService: self.serviceProvider.dataService) else { return }
            self.complicationService.updateComplication(allowance: user.allowance)
        }
    }

}
