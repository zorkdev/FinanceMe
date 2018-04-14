@testable import MyFinance_iOS

class MockAppStateiOS: AppStateiOSType {

    var dataService: DataService = MockDataService()
    var networkService: NetworkServiceType = MockNetworkService()
    var sessionService: SessionService = MockSessionService()
    var watchService: WatchServiceType = MockWatchService()
    var laContext: LAContextType = MockLAContext()
    var navigator: NavigatorType = MockNavigator(window: MockWindow())

}
