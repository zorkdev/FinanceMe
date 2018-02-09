public struct EndOfMonthSummaryBusinessLogic {

    public init() {}

    public func getEndOfMonthSummaryList() -> Promise<EndOfMonthSummaryList> {
        return NetworkService.shared.performRequest(api: .zorkdev(.endOfMonthSummaries),
                                                    method: .get)
    }

}
