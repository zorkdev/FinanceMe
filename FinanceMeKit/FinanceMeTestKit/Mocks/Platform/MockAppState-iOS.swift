@testable import FinanceMeKit

// swiftlint:disable force_cast
public class MockAppState: AppState {
    public var mockNetworkService: MockNetworkService { networkService as! MockNetworkService }
    public var mockSessionService: MockSessionService { sessionService as! MockSessionService }
    public var mockDataService: MockDataService { dataService as! MockDataService }
    public var mockLoggingService: MockLoggingService { loggingService as! MockLoggingService }
    public var mockConfigService: MockConfigService { configService as! MockConfigService }
    public var mockMetricService: MockMetricService { metricService as! MockMetricService }
    public var mockAuthenticationService: MockAuthenticationService { authenticationService as! MockAuthenticationService }
    public var mockSessionBusinessLogic: MockSessionBusinessLogic { sessionBusinessLogic as! MockSessionBusinessLogic }
    public var mockUserBusinessLogic: MockUserBusinessLogic { userBusinessLogic as! MockUserBusinessLogic }
    public var mockTransactionBusinessLogic: MockTransactionBusinessLogic {
        transactionBusinessLogic as! MockTransactionBusinessLogic
    }
    public var mockSummaryBusinessLogic: MockSummaryBusinessLogic { summaryBusinessLogic as! MockSummaryBusinessLogic }
    public var mockAuthenticationBusinessLogic: MockAuthenticationBusinessLogic {
        authenticationBusinessLogic as! MockAuthenticationBusinessLogic
    }

    override public init() {
        super.init(networkService: MockNetworkService(),
                   sessionService: MockSessionService(),
                   dataService: MockDataService(),
                   loggingService: MockLoggingService(),
                   configService: MockConfigService(),
                   metricService: MockMetricService(),
                   authenticationService: MockAuthenticationService(),
                   sessionBusinessLogic: MockSessionBusinessLogic(),
                   userBusinessLogic: MockUserBusinessLogic(),
                   transactionBusinessLogic: MockTransactionBusinessLogic(),
                   summaryBusinessLogic: MockSummaryBusinessLogic(),
                   authenticationBusinessLogic: MockAuthenticationBusinessLogic())
    }
}
