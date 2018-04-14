import MyFinanceKit

struct MockAppState: NetworkServiceProvider, DataServiceProvider, SessionServiceProvider {

    var dataService: DataService = MockDataService()
    var networkService: NetworkServiceType = MockNetworkService()
    var sessionService: SessionService = MockSessionService()

}
