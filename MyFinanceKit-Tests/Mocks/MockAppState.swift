@testable import MyFinanceKit

struct MockNetworkDataServiceProvider: NetworkDataServiceProvider {
    var dataService: DataService = MockDataService()
    var networkService: NetworkServiceType = MockNetworkService()
}
