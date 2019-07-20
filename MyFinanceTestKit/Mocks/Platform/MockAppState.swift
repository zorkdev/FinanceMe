import MyFinanceKit

// swiftlint:disable force_cast
class MockAppState: NetworkServiceProvider, DataServiceProvider, SessionServiceProvider {
    var dataService: DataService = MockDataService()
    var mockDataService: MockDataService { return dataService as! MockDataService }

    var networkService: NetworkServiceType = MockNetworkService()
    var mockNetworkService: MockNetworkService { return networkService as! MockNetworkService }

    var sessionService: SessionService = MockSessionService()
    var mockSessionService: MockSessionService { return sessionService as! MockSessionService }
}
