@testable import MyFinance_iOS

struct MockAppStateiOS: AppStateiOSType {

    var dataService: DataService = MockDataService()
    var networkService: NetworkServiceType = MockNetworkService()
    var watchService: WatchServiceType = MockWatchService()
    var laContext: LAContextType = MockLAContext()
    var navigator: NavigatorType = MockNavigator(window: MockWindow())

}