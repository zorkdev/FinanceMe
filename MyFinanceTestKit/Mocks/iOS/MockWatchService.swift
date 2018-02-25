@testable import MyFinance_iOS

class MockWatchService: WatchServiceType {

    var didCallUpdateComplication = false

    init() {}

    required init(wcSession: WCSessionType, dataService: DataService) {}

    func updateComplication() {
        didCallUpdateComplication = true
    }

}
