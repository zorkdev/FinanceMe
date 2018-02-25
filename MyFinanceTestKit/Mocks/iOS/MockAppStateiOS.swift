@testable import MyFinance_iOS

struct MockAppStateiOS: NetworkServiceProvider, DataServiceProvider, WatchServiceProvider {

    var dataService: DataService = MockDataService()
    var networkService: NetworkServiceType = MockNetworkService()
    var watchService: WatchServiceType = MockWatchService()

}
