public struct EndOfMonthSummaryBusinessLogic {

    public init() {}

    public func getEndOfMonthSummaryList() -> Promise<EndOfMonthSummaryList> {
        guard let url = ZorkdevAPI.endOfMonthSummaries.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .get,
                                                    url: url)
            .then { data in
                guard let endOfMonthSummaryList = EndOfMonthSummaryList(data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return Promise(value: endOfMonthSummaryList)
        }
    }

}
