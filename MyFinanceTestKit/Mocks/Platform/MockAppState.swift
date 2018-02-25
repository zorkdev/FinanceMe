import MyFinanceKit

struct MockAppState: NetworkServiceProvider, DataServiceProvider {

    var dataService: DataService = MockDataService()
    var networkService: NetworkServiceType = MockNetworkService()

}
