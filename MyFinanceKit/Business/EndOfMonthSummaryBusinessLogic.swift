import PromiseKit

public struct EndOfMonthSummaryBusinessLogic {

    public init() {}

    public func getEndOfMonthSummaries() -> Promise<[EndOfMonthSummary]> {
        guard let url = ZorkdevAPI.endOfMonthSummaries.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .get,
                                                    url: url)
            .then { data in
                guard let endOfMonthSummaries = JSONCoder.shared.decode([EndOfMonthSummary].self, from: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return Promise(value: endOfMonthSummaries)
        }
    }

}
