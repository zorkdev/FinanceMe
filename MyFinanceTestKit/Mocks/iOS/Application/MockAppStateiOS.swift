@testable import MyFinance_iOS

class MockAppStateiOS: MockAppState, AppStateiOSType {

    var watchService: WatchServiceType = MockWatchService()
    var mockWatchService: MockWatchService { return watchService as! MockWatchService }

    var laContext: LAContextType = MockLAContext()
    var mockLAContext: MockLAContext { return laContext as! MockLAContext }

    var navigator: NavigatorType = MockNavigator(window: MockWindow())
    var mockNavigator: MockNavigator { return navigator as! MockNavigator }

}
