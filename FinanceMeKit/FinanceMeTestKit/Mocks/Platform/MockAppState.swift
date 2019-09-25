@testable import FinanceMeKit

// swiftlint:disable force_cast
public class MockAppState: AppState {
    public var mockNetworkService: MockNetworkService { networkService as! MockNetworkService }
    public var mockSessionService: MockSessionService { sessionService as! MockSessionService }
    public var mockDataService: MockDataService { dataService as! MockDataService }
    public var mockLoggingService: MockLoggingService { loggingService as! MockLoggingService }
    public var mockConfigService: MockConfigService { configService as! MockConfigService }
    public var mockSessionBusinessLogic: MockSessionBusinessLogic { sessionBusinessLogic as! MockSessionBusinessLogic }
    public var mockUserBusinessLogic: MockUserBusinessLogic { userBusinessLogic as! MockUserBusinessLogic }

    override public init() {
        super.init(networkService: MockNetworkService(),
                   sessionService: MockSessionService(),
                   dataService: MockDataService(),
                   loggingService: MockLoggingService(),
                   configService: MockConfigService(),
                   sessionBusinessLogic: MockSessionBusinessLogic(),
                   userBusinessLogic: MockUserBusinessLogic())
    }
}
