@testable import FinanceMeKit

// swiftlint:disable force_cast
public class MockAppState: AppStateType {
    public var networkService: NetworkService = MockNetworkService()
    public var mockNetworkService: MockNetworkService { networkService as! MockNetworkService }

    public var sessionService: SessionService = MockSessionService()
    public var mockSessionService: MockSessionService { sessionService as! MockSessionService }

    public var dataService: DataService = MockDataService()
    public var mockDataService: MockDataService { dataService as! MockDataService }

    public var loggingService: LoggingService = MockLoggingService()
    public var mockLoggingService: MockLoggingService { loggingService as! MockLoggingService }

    public var configService: ConfigService = MockConfigService()
    public var mockConfigService: MockConfigService { configService as! MockConfigService }

    public var sessionBusinessLogic: SessionBusinessLogicType = MockSessionBusinessLogic()
    public var mockSessionBusinessLogic: MockSessionBusinessLogic { sessionBusinessLogic as! MockSessionBusinessLogic }

    public var userBusinessLogic: UserBusinessLogicType = MockUserBusinessLogic()
    public var mockUserBusinessLogic: MockUserBusinessLogic { userBusinessLogic as! MockUserBusinessLogic }
}
