@testable import MyFinanceKit

class APIsTests: XCTestCase {
    let session = Factory.makeSession()

    func testAPIToken() {
        XCTAssertEqual(API.starling(.balance).token(session: session),
                       session.starlingToken)
        XCTAssertEqual(API.zorkdev(.user).token(session: session),
                       session.zorkdevToken)
    }

    func testAPIURL() {
        let starlingURL = API.starling(.balance).url
        let zorkdevURL = API.zorkdev(.user).url

        XCTAssertEqual(starlingURL, StarlingAPI.balance.url)
        XCTAssertEqual(zorkdevURL, ZorkdevAPI.user.url)
    }

    func testStarlingAPI() {
        XCTAssertNotNil(StarlingAPI.balance.url)
        XCTAssertNotNil(StarlingAPI.transactions.url)
    }

    func testZorkdevAPI() {
        XCTAssertNotNil(ZorkdevAPI.user.url)
        XCTAssertNotNil(ZorkdevAPI.endOfMonthSummaries.url)
        XCTAssertNotNil(ZorkdevAPI.transactions.url)

        let id = "uniqueID"
        let transactionURL = ZorkdevAPI.transaction(id).url
        XCTAssertNotNil(transactionURL)
        XCTAssertTrue(transactionURL?.absoluteString.contains(id) == true)
    }

    func testFromToParameters() {
        let now = Date()
        let dayBefore = now.dayBefore

        let fromTo = FromToParameters(from: dayBefore, to: now)

        XCTAssertEqual(fromTo.from, dayBefore)
        XCTAssertEqual(fromTo.to, now)
        XCTAssertEqual(FromToParameters.decodeDateFormatter, Formatters.apiDate)
        XCTAssertEqual(FromToParameters.encodeDateFormatter, Formatters.apiDate)
    }
}
